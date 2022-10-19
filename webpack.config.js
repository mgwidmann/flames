const webpack = require('webpack');
const MiniCssExtractPlugin = require('mini-css-extract-plugin');
const path = require('path');
// var autoprefixer = require('autoprefixer');
// require('bootstrap/css/bootstrap.css');

var BUILD_DIR = path.resolve(__dirname, 'priv/static');
var APP_DIR = path.resolve(__dirname, 'lib/web/static');

var config = {
  entry: [
    'bootstrap-loader',
    APP_DIR + '/js/flames-frontend.jsx'
  ],
  output: {
    path: BUILD_DIR,
    filename: './priv/static/js/flames-frontend.js'
  },
  plugins: [
    new webpack.DefinePlugin({
      'process.env': {
        'NODE_ENV': '"production"'
      }
    }),
    new MiniCssExtractPlugin({ filename: './priv/static/css/flames-frontend.css' }),
    // new ExtractTextPlugin('/css/flames-frontend.css', { allChunks: true }),
    new webpack.ProvidePlugin({
      $: "jquery",
      jQuery: "jquery",
      "window.jQuery": "jquery"
    })
  ],
  resolve: {
    extensions: ['', '.json', '.jsx', '.js']
  },
  module: {
    rules: [
      { test: /\.jsx?$/, use: [ { loader: 'babel-loader', options: { include: path.join(__dirname, 'lib/web/static') } } ] },
      { test: /\.css$/, use: [ { loader: 'style-loader'}, { loader: 'css-loader' }, { loader: 'postcss-loader' } ] },
      { test: /\.scss$/, use: [ { loader: 'style-loader' }, { loader: 'css-loader' }, { loader: 'postcss-loader' }, { loader: 'sass-loader' } ] },
      { test: /\.png$/, use: [ { loader: "url-loader?limit=100000" } ] },
      { test: /\.jpg$/, use: [ { loader: "file-loader" } ] },
      { test: /\.(woff2?|svg)$/, use: [ { loader: 'url-loader?limit=10000' } ] },
      { test: /\.(ttf|eot)$/, use: [ { loader: 'file-loader' } ] },
      { test: /\.json$/, use: [ { loader: "json-loader" } ] }
    ]
  }
};

module.exports = config;
