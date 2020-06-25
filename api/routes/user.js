var express = require("express");
var router = express.Router();
var _ = require("lodash");

const admin = require("../services/firebase").admin;
const sql = require("../services/mysql");

router.post("/deleteUser", async (req, res) => {
  const { uid } = req.body;
  try {
    await admin.auth().deleteUser(uid);
    res.sendStatus(200);
  } catch (error) {
    res.sendStatus(500);
  }
});

// Check if a UID already exists in DB. If not, create that user
router.post("/createUser", async (req, res) => {
  const { id, name, email } = req.body;
  try {
    let [response, responseFields] = await sql.query(`
      SELECT COUNT(id) as Count
      FROM Users
      WHERE id = "${id}";
    `);
    if (response[0].Count == 0) {
      await sql.query(
        `INSERT INTO USERS(id, name, email) VALUES("${id}", "${name}", "${email}");`
      );
    }
    res.sendStatus(200);
  } catch (error) {
    console.log(error);
    res.sendStatus(500);
  }
});

module.exports = router;
