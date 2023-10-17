const log = require("SyntheticsLogger");
const https = require("node:https");
const HEALTHCHECK_URL =
  process.env.HEALTHCHECK_URL ||
  "https://www.trade-tariff.service.gov.uk/api/v2/healthcheck";

const httpsGet = (url) => {
  let body = "";

  const promise = new Promise((resolve, reject) => {
    https
      .get(url, (res) => {
        res.setEncoding("utf8");
        res.on("data", (data) => (body += data));
        res.on("end", () => {
          let healthcheckResponse = JSON.parse(body);
          resolve(healthcheckResponse);
        });
      })
      .on("error", reject);
  });

  return promise;
};

const entryPoint = async function () {
  log.info("Starting healthcheck canary.");

  let flag = false;

  try {
    let response = await httpsGet(HEALTHCHECK_URL);
    delete response.git_sha1;
    log.info(`Response: ${response}`);

    for (const [key, value] of Object.entries(response)) {
      if (!value) {
        log.error(`${key} unhealthy.`);
        flag = true;
      }
    }
  } catch (err) {
    log.error(err);
    throw err;
  }

  if (flag) {
    throw "API healthcheck canary failure.";
  } else {
    return "Successfully completed healthcheck canary.";
  }
};

exports.handler = async () => {
  return await entryPoint();
};
