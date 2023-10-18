const synthetics = require("Synthetics");
const URL =
  process.env.URL ||
  "https://www.trade-tariff.service.gov.uk/search?q=red+herring";
const regex = /Search results for/g;

const entryPoint = async function () {
  const page = await synthetics.getPage();
  await synthetics.addUserAgent(page, "TradeTariffSynthetics-0.1");

  const response = await page.goto(URL, {
    waitUntil: ["domcontentloaded", "networkidle0"],
    timeout: 15000,
  });

  if (!response) {
    throw "Failed to load page!";
  }

  if (response.status() < 200 || response.status() > 299) {
    throw `Expected 2xx, received ${response.status()}.`;
  }

  const resultHeader = (await page.content()).match(regex);

  if (!resultHeader) {
    throw "Search results not loaded.";
  } else {
    return "Successfully completed search canary.";
  }
};

exports.handler = async () => {
  return await entryPoint();
};
