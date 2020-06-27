var express = require("express");
var path = require("path");
var cookieParser = require("cookie-parser");
var logger = require("morgan");
require("dotenv").config();

var app = express();

app.use(logger("dev"));
app.use(express.json());
app.use(express.urlencoded({ extended: false }));
app.use(cookieParser());

app.use("/user", require("./routes/user"));
app.use("/merchant", require("./routes/merchant"));
app.use("/order", require("./routes/order"));
app.use("/productData", require("./routes/productData"));

module.exports = app;
