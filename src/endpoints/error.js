// error handling
const errorHandler = (error, _req, res, _next) => {
  let resp;

  if (env == "prod") resp = { error: { message: "server error" } };
  else {
    console.error(error);
    resp = { message: error.message, error };
  }

  res.status(500).json(resp);
};

module.exports = errorHandler;
