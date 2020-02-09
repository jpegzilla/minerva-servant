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

  if (!req.body.user || !req.body.userUpdate) {
    return res.status(400).json({
      ok: false,
      message: "invalid request. must send user and userUpdate."
    });
  }

  try {
    const found = await db.find(req.body.user, type);
    if (found.length < 1)
      return res
        .status(400)
        .json({ ok: false, message: "record does not exist." });

    const op = await db.update(req.body.user, req.body.userUpdate, type);
    return res
      .status(200)
      .json({ ok: true, message: `${op.insertedCount} inserted.` });
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

  if (!req.body.item || !req.body.itemUpdate) {
    return res.status(400).json({
      ok: false,
      message: "invalid request. must send item and itemUpdate."
    });
  }

  try {
    const found = await db.find(req.body.item, type);
    if (found.length < 1)
      return res
        .status(400)
        .json({ ok: false, message: "record does not exist." });

    const op = await db.update(req.body.item, req.body.userUpdate, type);
    return res
      .status(200)
      .json({ ok: true, message: `${op.insertedCount} inserted.` });
  } catch (err) {
    return res.status(500).json({ ok: false, message: err });
  }
});

module.exports = router;
