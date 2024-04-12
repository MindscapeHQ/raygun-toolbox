import * as https from 'https';
import { Compiler } from 'webpack';

interface RaygunWebpackPluginOptions {
    applicationId: string;
    patToken: string;
    baseUri: string;
}

export class RaygunWebpackPlugin {
    private options: RaygunWebpackPluginOptions;

    constructor(options: RaygunWebpackPluginOptions) {
        this.options = options;
    }

    public apply(compiler: Compiler): void {
        compiler.hooks.emit.tapAsync('RaygunWebpackPlugin', (compilation, callback) => {
            Object.keys(compilation.assets).forEach(async (filepath) => {
                if (filepath.endsWith('.map')) {
                    const sourceMapContent = compilation.assets[filepath].source();
                    try {
                        await this.uploadSourceMap(filepath, typeof sourceMapContent === 'string' ? sourceMapContent : sourceMapContent.toString());
                        console.log(`Successfully uploaded ${filepath} to Raygun.`);
                    } catch (error) {
                        console.error(`Error uploading ${filepath}: ${error}`);
                    }
                }
            });

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

            // Add the sourceMap file part
            postData += delimiter;
            postData += `Content-Disposition: form-data; name="file"; filename="${filename}"\r\n`;
            postData += 'Content-Type: application/json\r\n\r\n';
            postData += sourceMapContent;

            // Add the URI part
            postData += delimiter;
            postData += `Content-Disposition: form-data; name="uri"\r\n\r\n`;
            postData += cleanedUrl;

            postData += closeDelimiter;

            const requestOptions = {
                hostname: 'api.raygun.com',
                port: 7272,
                path: `/v3/applications/${applicationId}/source-maps`,
                method: 'POST',
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
                        const errorMessage = `Failed to upload source map: HTTP status code ${res.statusCode}`;
                        console.error(errorMessage); // Print the error message if non-2xx response
                        reject(new Error(errorMessage));
                    }
                });
            });
            req.on('error', (error) => {
                reject(error);
                console.error(`Request error: ${error}`);
            });

            req.write(postData);
            req.end();
        });
    }
    private getFileNameFromPath(filePath: string) {
        // Normalize the path to use a consistent separator
        const normalizedPath = filePath.replace(/\\/g, '/');
        // Split the path by the directory separator and get the last element
        const parts = normalizedPath.split('/');
        return parts.pop(); // Extracts and returns the last segment (the file name)
    }
}
