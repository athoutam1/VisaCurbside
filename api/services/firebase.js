var admin = require("firebase-admin");

var serviceAccount = require("./serviceAccount.json");

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
  databaseURL: "https://visa-curbside.firebaseio.com",
});
var storage = admin.storage();

exports.admin = admin;
exports.storage = storage;
