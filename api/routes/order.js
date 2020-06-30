var express = require("express");
var router = express.Router();
var _ = require("lodash");

const admin = require("../services/firebase").admin;
const sql = require("../services/mysql");
const order = require("../models/order");


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
          response.storeName,
          response.itemIDs,
          response.total,
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
    let [response4, responseFields4] = await sql.query(`
    select sum(price)from orders 
    join ordereditems on orders.id = ordereditems.orderid 
    join items on ordereditems.itemid=items.id 
    where orders.id=${orderID};
  `);
      response[i].total = response4[0]['sum(price)'];
      
      let array = [];
      for (let c = 0; c < response2.length; c++) {
        array.push(response2[c].itemID)
      }
      response[i].itemIDs = array;
    }


    for (let i = 0; i < response.length; i++) {
      let storeID = response[i].storeID;
      let [response3, responseFields3] = await sql.query(`
      SELECT name FROM STORES WHERE id = ${storeID};
    `);
      response[i].storeName = response3[0].name
    }
    

    res.json(response);
  } catch (error) {
    console.error(error);
    res.sendStatus(500);
  }
});

module.exports = router;
