var express = require("express");
var router = express.Router();
var _ = require("lodash");

const storage = require("../services/firebase").storage;
const sql = require("../services/mysql");
const merchant = require("../models/merchant");

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
