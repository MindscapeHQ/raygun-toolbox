// webpack.config.js
const path = require('path');
const fs = require('fs');
const TerserPlugin = require('terser-webpack-plugin');
const MiniCssExtractPlugin = require('mini-css-extract-plugin');
const CssMinimizerPlugin = require('css-minimizer-webpack-plugin');
const { RaygunWebpackPlugin } = require('@raygun/webpack-plugin');

// Dynamically generate entry points
const entryPoints = {};
const srcDir = path.join(__dirname, 'src');
fs.readdirSync(srcDir).forEach(file => {
    if (file.endsWith('.js')) {
        const name = file.replace('.js', '');
        entryPoints[name] = `./src/${file}`;
    }
});

module.exports = {
    mode: 'production',
    entry: entryPoints,
    devtool: 'source-map',
    output: {
        filename: '[name].[contenthash].js',
        path: path.resolve(__dirname, 'dist'),
        clean: true
    },
    module: {
        rules: [
            {
                test: /\.js$/,
                exclude: /node_modules/,
                use: {
                    loader: 'babel-loader',
                    options: {
                        presets: ['@babel/preset-env']
                    }
                }
            },
            {
                test: /\.css$/,
                use: [MiniCssExtractPlugin.loader, 'css-loader']
            }
        ]
    },
    optimization: {
        minimize: true,
        minimizer: [
            new TerserPlugin({
                terserOptions: {
                    format: {
                        comments: false,
                    },
                },
                extractComments: false,
            }),
            new CssMinimizerPlugin(),
        ],
    },
    plugins: [
        new MiniCssExtractPlugin({
            filename: '[name].[contenthash].css'
        }),
        new RaygunWebpackPlugin({
            applicationId: '',
            patToken: '',
            baseUri: 'http://localhost:8080/',
            // Optional rate limiting settings
            delayBetweenFiles: 100,  // 2 second delay between files
            retryConfig: {
                maxRetries: 10,
                initialDelay: 100,
                maxDelay: 60000,
                backoffFactor: 3
            }
        })
    ]
};