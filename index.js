#!/usr/bin/env node

/*jshint esversion: 6 */
"use strict";

var http = require("http");
var path = require("path");

var express = require("express");
var RED = require("node-red");

var packageJson = require("./package.json");


var settings = {

    userDir: path.resolve(__dirname, "data"),
    nodesDir: path.resolve(__dirname, "data/nodes"),

    uiPort: 1880,
    uiHost: "0.0.0.0",

    httpStatic: "public",
    httpAdminRoot: "/edit/",
    httpNodeRoot: "/endpoints/",
    httpNodeCors: {
        origin: "*",
        methods: "GET,PUT,PATCH,POST,DELETE"
    },
    swagger: {
      template: {
        swagger: "2.0",
        info: {
          title: packageJson.name,
          description: '[HTTP/1.1](https://tools.ietf.org/html/rfc2616)',
          version: packageJson.version
        }
      }
    },

    // Anything in this hash is globally available to all functions.
    // It is accessed as context.global.
    // eg:
    //    functionGlobalContext: { os:require('os') }
    // can be accessed in a function block as:
    //    context.global.os
    functionGlobalContext: {
        crypto: require('crypto'),
        _: require('underscore'),
        async: require('async'),
        redis: require('redis'),
        pg: require('pg'),
        r: require('rethinkdb'),
        elasticsearch: require('elasticsearch'),
        influx: require('influx'),
        prometheus: require('prom-client'),
        cassandra: require('cassandra-driver'),
        arango: require('arangojs')
    },

    httpNodeMiddleware: (req,res,next) => {
      res.set("x-powered-by", "radapi");
      next();
    },
    // If you need to set an http proxy please set an environment variable
    // called http_proxy (or HTTP_PROXY) outside of Node-RED in the operating system.
    // For example - http_proxy=http://myproxy.com:8080
    // (Setting it here will have no effect)
    // You may also specify no_proxy (or NO_PROXY) to supply a comma separated
    // list of domains to not proxy, eg - no_proxy=.acme.co,.acme.co.uk

    // Retry time in milliseconds for MQTT connections
    mqttReconnectTime: 15000,

    // Retry time in milliseconds for Serial port connections
    serialReconnectTime: 15000,

    // Retry time in milliseconds for TCP socket connections
    socketReconnectTime: 10000,

    // Timeout in milliseconds for TCP server socket connections (defaults to no timeout)
    socketTimeout: 120000,

    // The maximum length, in characters, of any message sent to the debug sidebar tab
    debugMaxLength: 5000,

    // The file containing the flows. If not set, it defaults to flows_<hostname>.json
    flowFile: "flows.json",

    // Enabled pretty-printing of the flow within the flow file
    flowFilePretty: true,

    // The following property can be used to order the categories in the editor
    // palette. If a node's category is not in the list, the category will get
    // added to the end of the palette.
    // If not set, the following default order is used:
    paletteCategories: ["subflows", "input", "output", "function", "storage",  "advanced", "social", "analysis"],

    // Configure the logging output
    logging: {
        // Only console logging is currently supported
        console: {
            // Level of logging to be recorded. Options are:
            // fatal - only those errors which make the application unusable should be recorded
            // error - record errors which are deemed fatal for a particular request + fatal errors
            // warn - record problems which are non fatal + errors + fatal errors
            // info - record information about the general running of the application + warn + error + fatal errors
            // debug - record information which is more verbose than info + info + warn + error + fatal errors
            // trace - record very detailed logging + debug + info + warn + error + fatal errors
            level: "info",

            // Whether or not to include metric events in the log output
            metrics: false
        }
    }
};

var app = express();
app.set("etag", "strong");
app.use("/", express.static(path.resolve(__dirname, "public")));

var server = http.createServer(app);

RED.init(server, settings);

app.use(settings.httpAdminRoot, RED.httpAdmin);
app.use(settings.httpNodeRoot, RED.httpNode);

server.listen(settings.uiPort);

RED.start();
