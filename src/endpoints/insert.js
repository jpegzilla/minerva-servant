const express = require("express");
const router = express.Router();
const bodyParser = require("body-parser");

// parse application/x-www-form-urlencoded
router.use(bodyParser.urlencoded({ extended: false }));

// parse application/json
router.use(bodyParser.json());

// insert user to ma_users collection
router.post("/user", async (req, res) => {
  const type = "user";

  // validate body exists
  if (!req.body || Object.entries(req.body).length == 0) {
    return res
      .status(400)
      .json({ message: "invalid request. must send object" });
  }

  try {
    // try to find user by id. if it exists, return error
    const found = await db.findById(req.body, type);

    if (found.length > 1) return res.status(400).send("user already exists.");

    // try to insert to collection
    const op = await db.insert(req.body, type);

    return res.status(200).send(`${op.insertedCount} inserted.`);
  } catch (err) {
    // return error if insert or find fails
    return res.status(500).send({ ok: false, message: err });
  }
});

// try to insert document to ma_data
router.post("/data", async (req, res) => {
  const type = "data";

  // make sure body exists
  if (!req.body || Object.entries(req.body).length == 0) {
    return res
      .status(400)
      .json({ message: "invalid request. must send object" });
  }

  // make sure userId exists
  if (!req.body.userId)
    return res
      .status(400)
      .json({ message: "invalid request - missing userid." });

  try {
    // make sure a matching user exists, so all documents belong
    // to a particular user
    const ensureUser = await db.findByUser(
      { ...req.body, id: req.body.userId },
      "user"
    );

    if (ensureUser.length === 0)
      return res.status(400).send("no matching user.");

    // make sure a record with a matching id does not exist
    const found = await db.findById(req.body, type);

    if (found.length >= 1)
      return res.status(400).send("record already exists.");

    // try to insert to collection
    const op = await db.insert(req.body, type);

    return res
      .status(201)
      .json({ ok: true, message: `${op.insertedCount} inserted.` });
  } catch (err) {
    // if any of the above db methods fail, return error
    return res.status(500).json({ ok: false, message: err });
  }
});

module.exports = router;
