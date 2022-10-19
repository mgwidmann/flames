const webpack = require('webpack');
const ExtractTextPlugin = require('extract-text-webpack-plugin');
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
    filename: '/js/flames-frontend.js'
  },
  plugins: [
    new webpack.DefinePlugin({
      'process.env': {
        'NODE_ENV': '"production"'
      }
    }),
    new ExtractTextPlugin('/css/flames-frontend.css', { allChunks: true }),
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
    loaders: [
      { test: /\.jsx?$/, loaders: ['babel'], include: path.join(__dirname, 'lib/web/static') },
      { test: /\.css$/, loaders: [ 'style', 'css', 'postcss' ] },
      { test: /\.scss$/, loaders: [ 'style', 'css', 'postcss', 'sass' ] },
      { test: /\.png$/, loader: "url-loader?limit=100000" },
      { test: /\.jpg$/, loader: "file-loader" },
      { test: /\.(woff2?|svg)$/, loader: 'url?limit=10000' },
      { test: /\.(ttf|eot)$/, loader: 'file' },
      { test: /\.json$/, loader: "json-loader" }
    ]
  }
};

module.exports = config;
