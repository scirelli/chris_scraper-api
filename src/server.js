#!/usr/bin/env node

const express = require('express');
// const proxy = require('express-http-proxy');
// const request = require('request');
const _ = require('lodash');
const app = express();
const path = require('path');

var config = {};

config = _.merge({}, config);

app.use(require('compression')());
app.set('json spaces', 2);
app.use(require('cookie-parser')());
app.use(require('body-parser').urlencoded({
    extended: true
}));

//STATIC ROUTES
app.use('/js', express.static(path.join(__dirname, 'static/js')));
app.use('/html', express.static(path.join(__dirname, 'static/html')));
app.use('/doc', express.static(path.join(__dirname, 'static/doc')));
app.use('/style', express.static(path.join(__dirname, 'static/styles')));
app.use('/fonts', express.static(path.join(__dirname, 'static/fonts')));
app.use('/img', express.static(path.join(__dirname, 'static/imgs')));
app.use('/vendor', express.static(path.join(__dirname, '../node_modules')));
app.use('/', express.static(path.join(__dirname, 'static')));

app.get('/healthcheck', function(req, res) {
    res.json({
        message: 'Implment me please.'
    });
});

app.get('/', function(req, res) {
    res.sendFile(path.join(__dirname, 'static/html/index.html'));
});

//wildcard to redirect old server routes to angular route
app.get('*', function(req, res) {
    res.redirect('/#' + req.originalUrl);
});

app.listen(process.env.PORT || config.port || 1111, () => {
    console.log('Working dir: \'' + __dirname + '\'');
    console.log('Listening on http://localhost:' + (process.env.PORT || config.port || 1111));
});
