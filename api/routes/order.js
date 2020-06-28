var express = require("express");
var router = express.Router();
var _ = require("lodash");

const admin = require("../services/firebase").admin;
const sql = require("../services/mysql");
const order = require("../models/order");

// Message Merchant by providing userID, merchantID, and the message (just a string)
router.post("/messageMerchant", async (req, res) => {
  const { userID, merchantID, message } = req.body;
  console.log(`User ${userID} is messaging merchant ${merchantID}: ${message}`);
  try {
    res.json({
      response: "Hey, What's up",
    });
  } catch (error) {
    res.sendStatus(500);
  }
});

// User would send a request here automatically if Visa approves their payment
// Send the order ID so we can mark it as paid
router.post("/confirmPayment", async (req, res) => {
  const { orderID } = req.body;
  console.log(`Marking order ${orderID} as paid`);
  try {
    res.sendStatus(200);
  } catch (error) {
    res.sendStatus(500);
  }
});

// Tells the merchant that I'm here
// Send your userID and orderID
router.post("/here", async (req, res) => {
  const { orderID } = req.body;
  console.log(
    `Telling merchant in order ${orderID} that the user in order ${orderID} is here`
  );
  try {
    res.sendStatus(200);
  } catch (error) {
    res.sendStatus(500);
  }
});

// Get order details by ID
router.get("/details", async (req, res) => {
  const { orderID } = req.body;
  try {
    res.json(
      new order.Order(orderID, 3435, [43, 2343, 64536], "dasd2423asdasd")
    );
  } catch (error) {
    res.sendStatus(500);
  }
});

// Returns all orders for a specific user based on user.UID
router.get("/getOrdersByUser", async (req, res) => {
  const { userID } = req.query;
  console.log(
    `Getting all orders for user with uid: ${userID}`
  );
  try {
    let [response, responseFields] = await sql.query(`
        SELECT * FROM ORDERS WHERE SHOPPERID = "${userID}";
      `);
      response = response.map(
        (response) => 
        new order.Order(
          response.id,
          response.storeID,
          response.itemIDs,
          response.shopperID,
          response.isPending,
          response.isReadyForPickup,
          response.time
        )
      )
    for (let i = 0; i < response.length; i++) {
      let orderID = response[i].id;
      let [response2, responseFields2] = await sql.query(`
      SELECT itemID FROM ORDEREDITEMS WHERE ORDERID = ${orderID};
    `);
      let array = [];
      for (let c = 0; c < response2.length; c++) {
        array.push(response2[c].itemID)
      }
      response[i].itemIDs = array;
    }
    
    res.json(response);
  } catch (error) {
    console.error(error);
    res.sendStatus(500);
  }
});

module.exports = router;
