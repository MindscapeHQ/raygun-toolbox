import * as https from 'https';
import { Compiler } from 'webpack';

interface RaygunWebpackPluginOptions {
    // Required options
    applicationId: string;
    patToken: string;
    baseUri: string;
    // Optional rate limiting configuration
    retryConfig?: {
        maxRetries?: number;        // Maximum number of retry attempts (default: 3)
        initialDelay?: number;      // Initial delay in ms before first retry (default: 1000)
        maxDelay?: number;          // Maximum delay in ms between retries (default: 30000)
        backoffFactor?: number;     // Multiplier for exponential backoff (default: 2)
    };
    delayBetweenFiles?: number;    // Add delay between file uploads if you're hitting rate limits
}

export class RaygunWebpackPlugin {
    private options: RaygunWebpackPluginOptions;
    private readonly defaultRetryConfig = {
        maxRetries: 3,
        initialDelay: 1000,
        maxDelay: 30000,
        backoffFactor: 2
    };

    constructor(options: RaygunWebpackPluginOptions) {
        // Always have retry config, using defaults if not provided
        this.options = {
            ...options,
            retryConfig: {
                ...this.defaultRetryConfig,
                ...options.retryConfig
            }
        };
    }

    public apply(compiler: Compiler): void {
        compiler.hooks.emit.tapAsync('RaygunWebpackPlugin', async (compilation, callback) => {
            for (const filepath of Object.keys(compilation.assets)) {
                if (filepath.endsWith('.map')) {
                    const sourceMapContent = compilation.assets[filepath].source();
                    if (!!sourceMapContent) {
                        const uploadOperation = async () => {
                            await this.uploadSourceMap(
                                filepath, 
                                typeof sourceMapContent === 'string' ? sourceMapContent : sourceMapContent.toString()
                            );
                            console.log(`Successfully uploaded ${filepath} to Raygun.`);
                        };

                        try {
                            await this.retryOperation(uploadOperation);
                            
                            // Only add delay if explicitly configured
                            if (this.options.delayBetweenFiles) {
                                await this.delay(this.options.delayBetweenFiles);
                            }
                        } catch (error) {
                            console.error(`Failed to upload ${filepath} after ${this.options.retryConfig!.maxRetries} retries: ${error}`);
                        }
                    } else {
                        console.error(`No source map content found for ${filepath}`);
                    }
                }
            }

            callback();
        });
    }

    private uploadSourceMap(filePath: string, sourceMapContent: string): Promise<void> {
        return new Promise((resolve, reject) => {
            const { baseUri, applicationId, patToken } = this.options;
            const resolvedUrl = new URL(filePath, baseUri).toString();
            const cleanedUrl = resolvedUrl.replace(/\.map$/, '');
            const filename = this.getFileNameFromPath(filePath);

            const boundary = '----WebKitFormBoundary7MA4YWxkTrZu0gW';
            const delimiter = `\r\n--${boundary}\r\n`;
            const closeDelimiter = `\r\n--${boundary}--`;
            let postData = '';

            postData += delimiter + `Content-Disposition: form-data; name="file"; filename="${filename}"\r\n`;
            postData += 'Content-Type: application/json\r\n\r\n';
            postData += sourceMapContent;
            postData += delimiter + `Content-Disposition: form-data; name="uri"\r\n\r\n`;
            postData += cleanedUrl;
            postData += closeDelimiter;

            const requestOptions = {
                hostname: 'api.raygun.com',
                path: `/v3/applications/${applicationId}/source-maps`,
                method: 'PUT',
                headers: {
                    'Content-Type': `multipart/form-data; boundary=${boundary}`,
                    'Authorization': `Bearer ${patToken}`,
                    'Content-Length': Buffer.byteLength(postData),
                },
            };

            const req = https.request(requestOptions, (res) => {
                let body = '';
                res.on('data', (chunk) => body += chunk);
                res.on('end', () => {
                    if (typeof res.statusCode === 'number' && res.statusCode >= 200 && res.statusCode < 300) {
                        resolve();
                    } else {
                        reject(new Error(`HTTP status code ${res.statusCode || 'undefined'}`));
                    }
                });
            });

            req.on('error', (error) => {
                reject(error);
            });

            req.write(postData);
            req.end();
        });
    }

    private getFileNameFromPath(filePath: string): string {
        const normalizedPath = filePath.replace(/\\/g, '/');
        const parts = normalizedPath.split('/');
        return parts.pop() || '';
    }

    private delay(ms: number): Promise<void> {
        return new Promise(resolve => setTimeout(resolve, ms));
    }

    private async retryOperation<T>(operation: () => Promise<T>): Promise<T> {
        const config = this.options.retryConfig!;
        let retries = 0;
        let delay = config.initialDelay!;

        while (true) {
            try {
                return await operation();
            } catch (error) {
                retries++;
                if (retries > config.maxRetries!) {
                    throw error;
                }
                
                await this.delay(delay);
                delay = Math.min(delay * config.backoffFactor!, config.maxDelay!);
            }
        }
    }
}