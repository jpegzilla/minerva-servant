const express = require("express");
const router = express.Router();
const bodyParser = require("body-parser");
const { adminAuth } = require("./../middleware/auth");

// parse application/x-www-form-urlencoded
router.use(bodyParser.urlencoded({ extended: false }));

// parse application/json
router.use(bodyParser.json());

router.use(adminAuth);

router.delete("/users", async (_req, res) => {
  let resp,
    status = 200,
    type = "user";
  try {
    resp = await db.empty(type);
  } catch (err) {
    status = 400;
    resp = { ok: false, message: "no collection available." };
  }
  return res.status(status).json(resp);
});

router.delete("/data", async (_req, res) => {
  let resp,
    status = 200,
    type = "data";
  try {
    resp = await db.empty(type);
  } catch (err) {
    status = 400;
    resp = { ok: false, message: "no collection available." };
  }
  return res.status(status).json(resp);
});

module.exports = router;
