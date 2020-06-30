var express = require("express");
var router = express.Router();
const axios = require("axios");
const db = require("../services/firebase").db;
const admin = require("../services/firebase").admin;

router.get("/", async function (req, res) {
  const { message, storeID, userID } = req.query;
  console.log(req.query)
  
  const chatRef = db.collection("chats").doc(`${userID}AND${storeID}`);
  try {
    await chatRef.update({
      messages: admin.firestore.FieldValue.arrayUnion({
      message: message,
      messenger: "user",
    })
    // messages: [
    //   {
    //     message,
    //     messenger: "user",
    //   },
    // ],
    });
  } catch (e) {
    await chatRef.set({
    //   messages: admin.firestore.FieldValue.arrayUnion({
    //   message: message,
    //   messenger: "user",
    // })
    messages: [
      {
        message,
        messenger: "user",
      },
    ],
    });
    console.log(e)
  }

  try {
    var config = {
      method: "get",
      params: {
        sessionId: "randomStuff",
        q: message,
      },
    };
    let response = await axios.get(
      "https://console.dialogflow.com/api-client/demo/embedded/8a7b64bd-898a-44c4-8f30-09bfffd3a818/demoQuery",
      config
    );
    let responseSpeech = response.data.result.fulfillment.speech;
    if (responseSpeech == "Sorry, I can't help you with that.") {
      // The merchant needs to respond
    } else {
      await chatRef.update({
        messages: admin.firestore.FieldValue.arrayUnion({
          message: responseSpeech,
          messenger: "veronica",
        }),
      });
    }
    res.sendStatus(200);
  } catch (e) {
    console.log(e);
    res.sendStatus(500);
  }
});

module.exports = router;
