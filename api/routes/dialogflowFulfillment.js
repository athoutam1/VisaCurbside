var express = require("express");
var router = express.Router();
const sql = require("../services/mysql");

const { WebhookClient } = require("dialogflow-fulfillment");
const { Card, Suggestion, Image } = require("dialogflow-fulfillment");

function welcome(agent) {
  agent.add(`Hello, how can I help you?`);
}

function fallback(agent) {
  agent.add(`Sorry, I can't help you with that.`);
}

const parkingInfo = async (agent) => {
  let [response, responseFields] = await sql.query(`
        SELECT parkingDetails FROM Stores
        WHERE id = 1;
    `);
  agent.add(response[0].parkingDetails);
};

const storeHours = async (agent) => {
  let [response, responseFields] = await sql.query(`
    SELECT openTime, closeTime FROM Stores
    WHERE id = 1;
    `);
  const open = response[0].openTime;
  const close = response[0].closeTime;

  agent.add(`We open today at ${open} and close at ${close}`);
};

const WebhookProcessing = (req, res) => {
  const agent = new WebhookClient({ request: req, response: res });

  let intentMap = new Map();
  intentMap.set("Default Welcome Intent", welcome);
  intentMap.set("Default Fallback Intent", fallback);
  intentMap.set("Parking Info", parkingInfo);
  intentMap.set("Store Hours", storeHours);
  agent.handleRequest(intentMap);
};

router.post("/", function (req, res) {
  WebhookProcessing(req, res);
});

module.exports = router;
