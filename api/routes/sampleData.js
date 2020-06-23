var express = require("express");
var router = express.Router();
var _ = require("lodash");

/* GET home page. */
router.get("/", function (req, res, next) {
  res.json({
    text: new Date().toString(),
    number: _.random(1, 10),
  });
});

module.exports = router;
