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
    await sql.query(`
      CREATE TABLE Stores(
        id INT PRIMARY KEY,
        name VARCHAR(255) NOT NULL,
        merchantID VARCHAR(255) NOT NULL,
        merchantName VARCHAR(255) NOT NULL,
        description MEDIUMTEXT NOT NULL,
        location MEDIUMTEXT NOT NULL
      );
    `);
    await sql.query(`
      INSERT INTO Stores(id, name, merchantID, merchantName, description, location) 
      VALUES(1, "Publix in Tampa", "asd87870dd", "Publix", "this store sells food", "123 Publix Tampa Dr, USA");
    `);
    await sql.query(`
      INSERT INTO Stores(id, name, merchantID, merchantName, description, location) 
      VALUES(2, "Target Atlantic Station", "SID1", "Target", "food and home stuff", "Atlantic Station Dr, Atlanta, GA");
    `);
    await sql.query(`
      CREATE TABLE Items(
        id INT PRIMARY KEY AUTO_INCREMENT,
        name VARCHAR(255) NOT NULL,
        price DOUBLE NOT NULL,
        description MEDIUMTEXT NOT NULL,
        imageURL MEDIUMTEXT,
        storeID INT NOT NULL,
        FOREIGN KEY (storeID) REFERENCES Stores(id)
      );
    `);
    await sql.query(`
      INSERT INTO Items(name, price, description, imageURL, storeID)
      VALUES("Ketchup", 2.99, "Tomato Sauce", "https://images-na.ssl-images-amazon.com/images/I/8199Xb1cVdL._SL1500_.jpg", 1);
    `);
    await sql.query(`
      CREATE TABLE Orders(
        id INT PRIMARY KEY AUTO_INCREMENT,
        shopperID VARCHAR(255) NOT NULL,
        storeID VARCHAR(255) NOT NULL,
        isPending BOOL NOT NULL,
        isReadyForPickup BOOL NOT NULL, 
        time TIMESTAMP NOT NULL,
        FOREIGN KEY (shopperID) REFERENCES Users(id)
      );
    `);
    await sql.query(`
      CREATE TABLE OrderedItems(
        id INT PRIMARY KEY AUTO_INCREMENT,
        itemID INT NOT NULL,
        orderID INT NOT NULL,
        shopperID VARCHAR(255) NOT NULL,
        FOREIGN KEY (orderID) REFERENCES Orders(id),
        FOREIGN KEY (shopperID) REFERENCES Users(id)
      );
    `);
  } catch (e) {
    console.log(e);
  } finally {
    process.exit(0);
  }
})();
