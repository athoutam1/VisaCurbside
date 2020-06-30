var express = require("express");
var router = express.Router();
var _ = require("lodash");

const sql = require("../services/mysql");
const merchant = require("../models/merchant");
const db = require("../services/firebase").db;
const admin = require("../services/firebase").admin;

// Takes in search query and returns a store preview (info to put in search results)
router.get("/search", async (req, res) => {
  const { query } = req.query;
  try {
    let [response, responseFields] = await sql.query(`
      SELECT * FROM Stores
      WHERE lower(name) LIKE '${query.toLowerCase()}%'
      LIMIT 10;    
    `);
    response = response.map(
      (response) =>
        new merchant.StorePreview(
          response.merchantID,
          response.merchantName,
          response.id,
          response.name,
          response.location
        )
    );
    res.json(response);
  } catch (error) {
    res.sendStatus(500);
  }
});

// Takes in store ID and returns the full store details (for the store details page)
router.get("/storeDetails", async (req, res) => {
  const { id } = req.query;
  try {
    let [response, responseFields] = await sql.query(`
      SELECT * FROM Stores
      WHERE id = ${id};
    `);
    if (response.length == 0) res.sendStatus(400);
    response = new merchant.Store(
      response[0].merchantID,
      response[0].merchantName,
      response[0].id,
      response[0].name,
      response[0].description,
      response[0].location,
      response[0].imageURL
    );
    res.json(response);
  } catch (error) {
    res.sendStatus(500);
  }
});

// Takes in storeID and search query and returns an item preview (info to put in search results)
router.get("/itemSearch", async (req, res) => {
  const { storeID, query } = req.query;
  try {
    let [response, responseFields] = await sql.query(`
      SELECT * FROM Items
      WHERE storeID = "${storeID}" AND lower(name) LIKE '${query.toLowerCase()}%'
      LIMIT 10;    
    `);
    response = response.map(
      (response) =>
        new merchant.ItemPreview(
          response.id,
          response.name,
          response.price,
          response.description,
          response.imageURL
        )
    );
    res.json(response);
  } catch (error) {
    res.sendStatus(500);
  }
});

// Takes in item ID and returns the full item details (for the item details page)
router.get("/itemDetails", async (req, res) => {
  const { itemID } = req.query;
  try {
    let [response, responseFields] = await sql.query(`
      SELECT * FROM Items
      WHERE id = ${itemID};
    `);
    if (response.length == 0) res.sendStatus(400);
    response = new merchant.Item(
      response[0].id,
      response[0].name,
      response[0].price,
      response[0].imageURL,
      response[0].description
    );
    res.json(response);
  } catch (error) {
    res.sendStatus(500);
  }
});

router.post("/changeOrderStatus", async (req, res) => {
  const { orderID, isPending, isReadyForPickup } = req.body;
  try {
    await sql.query(`
      UPDATE Orders
      SET isPending = ${isPending ? 1 : 0}, isReadyForPickup = ${
      isReadyForPickup ? 1 : 0
    }, time = NOW()
      WHERE id = ${orderID};
    `);

    if (!isPending && !isReadyForPickup) {
      // Delete chat from firebase
      let [response, responseFields] = await sql.query(`
        select shopperID, storeID
        from orders;
      `);
      await db
        .collection("chats")
        .doc(`${response[0].shopperID}AND${response[0].storeID}`)
        .delete();
    }
    res.sendStatus(200);
  } catch (error) {
    res.sendStatus(500);
  }
});

// Takes in list of item IDs, storeID, and user ID
router.post("/confirmOrder", async (req, res) => {
  const { storeID, itemIDs, userID, coordinates } = req.body;
  
  console.log(
    `User with ID ${userID} is trying to buy ${itemIDs} at store ${storeID}`
  );
  try {
    let [response, responseFields] = await sql.query(`
        INSERT INTO Orders(shopperID, storeID, isPending, isReadyForPickup, time, coordinates)
        VALUES("${userID}", "${storeID}", 1, 0, NOW(), "${coordinates}");
      `);
    let orderID = response.insertId;
    for (const itemID of itemIDs) {
      await sql.query(`
        INSERT INTO orderedItems(itemID, orderID, shopperID)
        VALUES(${itemID}, ${orderID}, "${userID}");
      `);
    }
    res.json({
      orderID,
    });
  } catch (error) {
    console.error(error);
    res.sendStatus(500);
  }
});

module.exports = router;
