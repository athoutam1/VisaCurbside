var express = require("express");
var router = express.Router();
var _ = require("lodash");

const admin = require("../services/firebase").admin;
const sql = require("../services/mysql");
const merchant = require("../models/merchant");

// Takes in search query and returns a merchant preview (info to put in search results)
router.get("/search", async (req, res) => {
  const { query } = req.query;
  try {
    res.json([
      new merchant.MerchantPreview(1, "Costco"),
      new merchant.MerchantPreview(2, "Publix"),
    ]);
  } catch (error) {
    res.sendStatus(500);
  }
});

// Takes in search query and returns an item preview (info to put in search results)
router.get("/itemSearch", async (req, res) => {
  const { query } = req.query;
  try {
    res.json([
      new merchant.ItemPreview(1, "Ketchup", 5),
      new merchant.ItemPreview(2, "Hot Sauce", 7),
    ]);
  } catch (error) {
    res.sendStatus(500);
  }
});

// Takes in merchant ID and returns the full merchant details (for the merchant page)
router.get("/merchantDetails", async (req, res) => {
  const { id } = req.query;
  try {
    const m = new merchant.Merchant(
      Number(id),
      "Costco",
      "this is a store that sells bulk thing",
      "124 Costco Dr, United States"
    );
    res.json(m);
  } catch (error) {
    res.sendStatus(500);
  }
});

// Takes in merchant ID and item ID and returns the full item details (for the item details page)
router.get("/itemDetails", async (req, res) => {
  const { merchantID, itemID } = req.query;
  try {
    const i = new merchant.Item(
      Number(itemID),
      "Lay's Chips",
      "these are potato chips",
      2.99
    );
    res.json(i);
  } catch (error) {
    res.sendStatus(500);
  }
});

// Takes in list of item IDs, merchantID, and user ID
router.post("/confirmOrder", async (req, res) => {
  const { merchantID, itemIDs, userID } = req.body;
  console.log(
    `User with ID ${userID} is trying to buy ${itemIDs} at merchant ${merchantID}`
  );
  try {
    res.json({
      orderID: 123,
    });
  } catch (error) {
    res.sendStatus(500);
  }
});

module.exports = router;
