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

module.exports = router;
