// authorization for admin-only endpoints

const { key } = require("./../config");

const adminAuth = (req, res, next) => {
  if (!req.headers.authorization)
    return res.status(403).send("you are not authorized.");
  else if (req.headers.authorization !== `admin ${key}`)
    return res.status(403).send("you are not authorized.");
  else next();
};

const userAuth = (req, res, next) => {
  const { authorization } = req.headers || null;

  console.log(req.body);

  // if (!req.headers.authorization)
  //   return res.status(403).send("you are not authorized.");
  // else if (req.headers.authorization !== `user ${req.body.userId}`)
  //   return res.status(403).send("you are not authorized.");
  // else next();
};

module.exports = { adminAuth, userAuth };
