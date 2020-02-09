const express = require("express");
const router = express.Router();
const bodyParser = require("body-parser");

// parse application/x-www-form-urlencoded
router.use(bodyParser.urlencoded({ extended: false }));

// parse application/json
router.use(bodyParser.json());

router.delete("/users", async (req, res) => {
  let resp,
    status = 200,
    type = "user";

  if (!req.body.id) {
    return res
      .status(400)
      .send({ ok: false, message: "invalid object to delete." });
  }

  try {
    resp = await db.delete(req.body, type);
  } catch (err) {
    status = 400;
    resp = { ok: false, message: "no collection available." };
  }

  return res.status(status).json(resp);
});

router.delete("/data", async (req, res) => {
  let resp,
    status = 200,
    type = "data";

  if (!req.body.id) {
    return res
      .status(400)
      .send({ ok: false, message: "invalid object to delete." });
  }

  try {
    resp = await db.delete(req.body, type);
  } catch (err) {
    status = 400;
    resp = { ok: false, message: "no collection available." };
  }

  return res.status(status).json(resp);
});

module.exports = router;
