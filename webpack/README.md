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
            baseUri: 'YOUR_WEBSITE_BASE_URI', 
            applicationId: 'YOUR_APPLICATION_ID',
            patToken: 'YOUR_PAT_TOKEN',
        })
    ]
};

```
Configuration Options
- baseUri (required): Specifies the base URI for your website E.g. `http://localhost:3000/`.
- applicationId (required): Your Raygun application identifier. 
- patToken (required): Your Raygun Personal Access Token with Sourcemap write permissions. Can be generated here: https://app.raygun.com/user/tokens

## How it works
Raygun looks for sourcemaps based on the url for the .js file where the error occored, when you upload a sourcemap you must also provide that url as a key for the map file. The plugin - using your base URI - will find all built sourcemaps and will attempt to construct the URL based on the build directory.


# Building 
```
npm run build
```

# Support
For support with the Raygun Webpack Plugin, please open an issue in our GitHub repository.
