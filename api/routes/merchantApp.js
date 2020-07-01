var express = require("express");
var router = express.Router();
var _ = require("lodash");

const storage = require("../services/firebase").storage;
const sql = require("../services/mysql");
const merchant = require("../models/merchant");
const orders = require("../models/order");
const db = require("../services/firebase").db;
const admin = require("../services/firebase").admin;

router.post("/approveOrder", async (req, res) => {
  const { orderID } = req.body;
  try {
    await sql.query(`
      UPDATE Orders
      SET isPending = 1, isReadyForPickup = 1
      WHERE id = ${orderID}
    `);
    res.sendStatus(200);
  } catch (error) {
    res.sendStatus(500);
  }
});

router.post("/orderDelivered", async (req, res) => {
  const { orderID } = req.body;
  try {
    await sql.query(`
      UPDATE Orders
      SET isPending = 0, isReadyForPickup = 0
      WHERE id = ${orderID}
    `);
    res.sendStatus(200);
  } catch (error) {
    res.sendStatus(500);
  }
});

router.post("/addItemToCatalog", async (req, res) => {
  const { name, price, description, imageURL, storeID } = req.body;
  try {
    let [response, responseFields] = await sql.query(`
      INSERT INTO Items(name, price, description, imageURL, storeID) values("${name}", 
      ${Number(price)}, "${description}", "${imageURL}", ${Number(storeID)});
    `);
    res.json({ itemID: response.insertId });
  } catch (error) {
    res.sendStatus(500);
  }
});

router.get("/messageShopper", async (req, res) => {
  const { storeID, shopperID, message } = req.query;
  try {
    const chatRef = db.collection("chats").doc(`${shopperID}AND${storeID}`);

    try {
      await chatRef.update({
        messages: admin.firestore.FieldValue.arrayUnion({
          message: message,
          messenger: "store",
        }),
      });
    } catch (e) {
      await chatRef.set({
        messages: [
          {
            message,
            messenger: "store",
          },
        ],
      });
    }

    // if (chatRef.get() && chatRef.get().exists) {
    // await chatRef.update({
    //   messages: admin.firestore.FieldValue.arrayUnion({
    //     message: message,
    //     messenger: "store",
    //   }),
    // });
    // } else {
    //   console.log("no");
    //   await chatRef.set(
    //     {
    //       messages: [
    //         {
    //           message,
    //           messenger: "store",
    //         },
    //       ],
    //     },
    //     { merge: true }
    //   );
    // }

    res.sendStatus(200);
  } catch (error) {
    console.log(error);
    res.sendStatus(500);
  }
});

router.post("/getItemsForStore", async (req, res) => {
  const { storeID } = req.body;
  try {
    let [response, responseFields] = await sql.query(`
      SELECT * FROM Items
      WHERE storeID = ${storeID}
    `);
    response = response.map((item) => {
      return new merchant.Item(
        item.id,
        item.name,
        item.price,
        item.imageURL,
        item.description
      );
    });
    res.json(response);
  } catch (error) {
    res.sendStatus(500);
  }
});

router.get("/getOrders", async (req, res) => {
  const { storeID } = req.query;
  try {
    let [response, responseFields] = await sql.query(`
      SELECT Orders.id, shopperID, isPending, isReadyForPickup, time, name as shopperName, coordinates FROM Orders
      JOIN Users
      ON Users.id = Orders.shopperID
      WHERE storeID = ${storeID}
    `);
    for (let order of response) {
      order.isPending = Boolean(order.isPending);
      order.isReadyForPickup = Boolean(order.isReadyForPickup);
    }
    res.json(response);
  } catch (error) {
    res.sendStatus(500);
  }
});

router.get("/getOrderItems", async (req, res) => {
  const { orderID } = req.query;
  try {
    let [response, responseFields] = await sql.query(`
      SELECT Items.id, name, description, price, imageURL FROM OrderedItems
      JOIN Items
      ON Items.id = OrderedItems.id
      WHERE orderID = ${orderID};
    `);
    res.json(response);
  } catch (e) {
    console.log(e);
    res.sendStatus(500);
  }
});

// TODO: Delete IMAGEURL from firestore DB
router.post("/deleteItemFromStore", async (req, res) => {
  const { itemID } = req.body;
  try {
    let [response, responseFields] = await sql.query(`
      SELECT ImageURL FROM Items
      WHERE id = ${itemID};
    `);
    let deletedImageURL = response[0].ImageURL;
    if (deletedImageURL.includes("firebasestorage.googleapis.com")) {
      const urlComponents = decodeURIComponent(deletedImageURL).split("/");
      const fileName = urlComponents[urlComponents.length - 1].split("?")[0];
      const fileFolder = urlComponents[urlComponents.length - 2];
      const bucket = storage.bucket("visa-curbside.appspot.com");
      await bucket.deleteFiles({
        prefix: `${fileFolder}/${fileName}`,
      });
    }
    await sql.query(`
      DELETE FROM Items
      WHERE id = ${itemID};
    `);
    res.sendStatus(200);
  } catch (err) {
    console.log(err);
    res.sendStatus(500);
  }
});

module.exports = router;
