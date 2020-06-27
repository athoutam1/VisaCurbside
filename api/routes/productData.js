var express = require("express");
var router = express.Router();
var _ = require("lodash");
const cheerio = require("cheerio");
const axios = require("axios");
const puppeteer = require("puppeteer");

// const browser = require("../services/puppeteer").browser;
var browser;
var page;
(async (_) => {
  browser = await puppeteer.launch({
    headless: true,
  });

  page = await browser.newPage();
})();

// Takes in barcode and estimates item details
router.get("/", async (req, res) => {
  try {
    await page.goto(
      `https://www.amazon.com/s?k=${req.body.barcode}&ref=nb_sb_noss`,
      { waitUntil: "networkidle2" }
    );
    let $ = cheerio.load(await page.content());

    const findLink = async (_) => {
      return await new Promise((resolve, reject) => {
        $(".s-result-item .a-size-mini a").each((i, element) => {
          const link = $(element).attr("href");
          if (link.includes(`/dp/`)) {
            resolve(`https://amazon.com${link}`);
          }
        });
        reject();
      });
    };

    let link = await findLink();

    // response = await axios.get(link);
    // $ = cheerio.load(response.data);
    await page.goto(link, { waitUntil: "networkidle2" });
    $ = cheerio.load(await page.content());
    let name = $("#productTitle").text()
      ? $("#productTitle").text().trim()
      : null;
    let price = $("#priceblock_ourprice").text()
      ? $("#priceblock_ourprice").text().trim().substring(1)
      : null;
    let description = $("#featurebullets_feature_div").text()
      ? $("#featurebullets_feature_div").text().trim()
      : null;
    let imageURL = $("#landingImage").attr("src")
      ? Object.keys(
          JSON.parse($("#landingImage").attr("data-a-dynamic-image"))
        )[0]
      : null;

    res.json({
      name,
      price,
      description,
      imageURL,
    });
  } catch (error) {
    console.log(error);
    res.sendStatus(500);
  }
});

module.exports = router;
