const express = require("express");
const router = express.Router();
const bodyParser = require("body-parser");

// parse application/x-www-form-urlencoded
router.use(bodyParser.urlencoded({ extended: false }));

// parse application/json
router.use(bodyParser.json());

router.post("/user", async (req, res) => {
  const type = "user";
  console.log(req.body);
  if (!req.body || Object.entries(req.body).length == 0) {
    return res
      .status(400)
      .json({ message: "invalid request. must send object" });
  }

  try {
    const found = await db.find(req.body, type);
    if (found.length > 0) return res.status(200).json(found);
    else return res.status(400).json({ ok: false, message: "not found" });
  } catch (err) {
    return res.status(500).json({ ok: false, message: err });
  }
});

router.post("/data", async (req, res) => {
  const type = "data";

  console.log(req.body);
  if (!req.body || Object.entries(req.body).length == 0) {
    return res
      .status(400)
      .json({ message: "invalid request. must send object" });
  }

  try {
    const found = await db.find(req.body, type);
    if (found.length > 0) return res.status(200).json(found);
    else return res.status(400).json({ ok: false, message: "not found" });
  } catch (err) {
    return res.status(500).json({ ok: false, message: err });
  }
});

module.exports = router;
