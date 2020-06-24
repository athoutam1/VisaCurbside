const path = require("path");
require("dotenv").config({
  path: path.resolve(__dirname, "../.env"),
});

var mysql = require("mysql2");
const pool = mysql.createPool({
  host: "localhost",
  user: process.env.SQL_USER,
  password: process.env.SQL_PASSWORD,
  database: "VisaCurbside",
});
const promisePool = pool.promise();

exports.query = async (q) => {
  try {
    let [res, resFields] = await promisePool.query(q);
    return [res, resFields];
  } catch (e) {
    throw e;
  }
};
