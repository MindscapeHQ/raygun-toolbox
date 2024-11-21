# Raygun Webpack Plugin
The Raygun Webpack plugin automatically detects sourcemaps generated during your builds and sends them to Raygun, facilitating better error diagnostics by mapping minified code back to your original source code.

## Installation 

Npm:
```
npm install @raygun/webpack-plugin
```

Yarn:
```
yarn add @raygun/webpack-plugin
```

Bun:
```
bun install @raygun/webpack-plugin
```

## Usage
```js
const RaygunWebpackPlugin = require('raygun-webpack-plugin');

module.exports = {
    // Your existing webpack config...
    plugins: [
        new RaygunWebpackPlugin({
            // Required options
            baseUri: 'YOUR_WEBSITE_BASE_URI', 
            applicationId: 'YOUR_APPLICATION_ID',
            patToken: 'YOUR_PAT_TOKEN',
        })
    ]
};
```

## Configuration Options
Required Options:
- `baseUri`: Specifies the base URI for your website E.g. `http://localhost:3000/`.
- `applicationId`: Your Raygun application identifier. 
- `patToken`: Your Raygun Personal Access Token with Sourcemap write permissions. Can be generated here: https://app.raygun.com/user/tokens

Rate Limiting Help:
If you're encountering rate limits when uploading sourcemaps, you can add these optional configurations:

```js
new RaygunWebpackPlugin({
    // Required options...
    
    // Optional: Add delay between file uploads
    delayBetweenFiles: 2000,    // Wait 2 seconds between files
    
    // Optional: Customize retry behavior
    retryConfig: {
        maxRetries: 5,          // Try up to 5 times (default: 3)
        initialDelay: 2000,     // Start with 2 second delay (default: 1000)
        maxDelay: 60000,        // Cap delays at 1 minute (default: 30000)
        backoffFactor: 3        // Triple the delay after each attempt (default: 2)
    }
})
```

The plugin includes built-in retry logic for failed uploads:
- Failed uploads will be retried up to 3 times with exponential backoff
- Initial retry delay: 1 second
- Maximum retry delay: 30 seconds
- Backoff multiplier: 2

If you're experiencing rate limit issues, you can:
1. Add a delay between file uploads using `delayBetweenFiles`
2. Adjust the retry settings using `retryConfig`

## How it works
Raygun looks for sourcemaps based on the url for the .js file where the error occurred, when you upload a sourcemap you must also provide that url as a key for the map file. The plugin - using your base URI - will find all built sourcemaps and will attempt to construct the URL based on the build directory.

# Development

## Building 
```
npm run build
```

# Support
For support with the Raygun Webpack Plugin, please open an issue in our GitHub repository.