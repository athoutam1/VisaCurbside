const sql = require("../services/mysql");
const path = require("path");

// Just to setup the DB
require("dotenv").config({
  path: path.resolve(__dirname, "../.env"),
});
var mysql = require("mysql2");
const pool = mysql.createPool({
  host: "localhost",
  user: process.env.SQL_USER,
  password: process.env.SQL_PASSWORD,
});
const promisePool = pool.promise();

(async (_) => {
  try {
    await promisePool.query(`DROP DATABASE IF EXISTS VisaCurbside;`);
    await promisePool.query(`CREATE DATABASE VisaCurbside;`);
    // DB is setup now, so we can connect to it directly
    await sql.query(`DROP TABLE IF EXISTS Users;`);
    await sql.query(`
    CREATE TABLE Users(
      id VARCHAR(255) PRIMARY KEY,
      name VARCHAR(255) NOT NULL,
      email VARCHAR(255) NOT NULL
  );
`);
  } catch (e) {
    console.log(e);
  } finally {
    process.exit(0);
  }
})();
