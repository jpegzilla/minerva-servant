const express = require("express");
const router = express.Router();
const bodyParser = require("body-parser");

// parse application/x-www-form-urlencoded
router.use(bodyParser.urlencoded({ extended: false }));

// parse application/json
router.use(bodyParser.json());

// endpoint for updating user documents in ma_users collection
router.post("/user", async (req, res) => {
  const type = "user";

  // check to ensure valid body
  if (!req.body || Object.entries(req.body).length == 0) {
    return res
      .status(400)
      .json({ message: "invalid request. must send object" });
  }

  // check to make sure there is a user and an object to update the user
  if (!req.body.user || !req.body.userUpdate) {
    return res.status(400).json({
      ok: false,
      message: "invalid request. must send user and userUpdate."
    });
  }

  try {
    // try to find the user by their id
    const found = await db.findById(req.body.user, type);
    if (found.length < 1)
      return res
        .status(400)
        .json({ ok: false, message: "record does not exist." });

    // try to update the user with the provided object
    const op = await db.update(req.body.user, req.body.userUpdate, type);

    return res
      .status(200)
      .json({ ok: true, message: `${op.insertedCount} inserted.` });
  } catch (err) {
    // return error if either db method above fails
    return res.status(500).json({ ok: false, message: err });
  }
});

// try to update a document in the ma_data collection
router.post("/data", async (req, res) => {
  const type = "data";

  // validate request body
  if (!req.body || Object.entries(req.body).length == 0) {
    return res
      .status(400)
      .json({ message: "invalid request. must send object" });
  }

  // ensure request body structure
  if (!req.body.item || !req.body.itemUpdate) {
    return res.status(400).json({
      ok: false,
      message: "invalid request. must send item and itemUpdate."
    });
  }

  try {
    // find the document by id
    const found = await db.findById(req.body.item, type);
    if (found.length < 1)
      return res
        .status(400)
        .json({ ok: false, message: "record does not exist." });

    // update the document with provided update object
    const op = await db.update(req.body.item, req.body.userUpdate, type);

    return res
      .status(200)
      .json({ ok: true, message: `${op.insertedCount} inserted.` });
  } catch (err) {
    // if either db method fails, return error
    return res.status(500).json({ ok: false, message: err });
  }
});

module.exports = router;
