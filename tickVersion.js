#!/usr/bin/env node

const fs = require('fs');

const MAJOR = 0,
    MINOR = 1,
    PATCH = 2;

const TYPE = 2;

var packageFile = require('./package'),
    currentVersion = packageFile.version;

if(currentVersion) {
    currentVersion = currentVersion.split('.').map(Number);

    switch(process.argv[TYPE]) {
        case '-M':
        case '--major':
            currentVersion[MAJOR]++;
            currentVersion[MINOR] = 0;
            currentVersion[PATCH] = 0;
            break;
        case '-p':
        case '--patch':
            currentVersion[PATCH]++;
            break;
        case '-m':
        case '--minor':
        default:
            currentVersion[MINOR]++;
            currentVersion[PATCH] = 0;
    }

    packageFile.version = currentVersion.join('.');

    fs.writeFile('./package.json', JSON.stringify(packageFile, null, '  '), function(err) {
        if(err) {
            return console.error(err);
        }
    });
}
