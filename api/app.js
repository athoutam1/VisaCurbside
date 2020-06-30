var express = require("express");
var path = require("path");
var cookieParser = require("cookie-parser");
var logger = require("morgan");
var cors = require("cors");
let ejs = require("ejs");
require("dotenv").config();

var app = express();

app.use(cors());
app.use(logger("dev"));
app.use(express.json());
app.use(express.urlencoded({ extended: false }));
app.use(cookieParser());
app.use(express.static("public"));
app.set("view engine", "ejs");

app.get("/", (req, res) => {
  // res.sendFile(path.join(__dirname + "/public/test.html"));
  res.render("pages/index", {
    amount: "20.00",
  });
});

app.use("/user", require("./routes/user"));
app.use("/merchant", require("./routes/merchant"));
app.use("/order", require("./routes/order"));
app.use("/productData", require("./routes/productData"));
app.use("/merchantApp", require("./routes/merchantApp"));
app.use("/messageMerchant", require("./routes/messageMerchant"));
app.use(
  "/dialogflowFirebaseFulfillment",
  require("./routes/dialogflowFulfillment")
);

module.exports = app;
