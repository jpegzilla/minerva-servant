require("dotenv").config();

const express = require("express");
const morgan = require("morgan");
const cors = require("cors");
const helmet = require("helmet");
const { env, key } = require("./config");

const Database = require("./utils/Database");
const dbName = "minerva_db";
const dbUrl = `mongodb://localhost:27017/${dbName}`;

const app = express();
const db = new Database(dbUrl);

db.connect(dbName);

global.db = db;

// console.log(key);

// endpoints
const errorHandler = require("./endpoints/error");
const insertEndpoint = require("./endpoints/insert");
const updateEndpoint = require("./endpoints/update");
const deleteEndpoint = require("./endpoints/delete");
const emptyCollEndpoint = require("./endpoints/emptycoll");

// middleware setup
app.use(morgan(env == "prod" ? "tiny" : "common"));
app.use(helmet());
app.use(cors());

app.use(errorHandler);

// insert endpoint
app.use("/insert", insertEndpoint);

// update endpoint
app.use("/update", updateEndpoint);

// delete endpoint
app.use("/delete", deleteEndpoint);

// empty collections
app.use("/emptycoll", emptyCollEndpoint);

// main endpoint
app.get("/", (_req, res) => {
  res.send("hello world!");
});

module.exports = app;
