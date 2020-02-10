const app = require("./index");
const { port } = require("./config");

app.listen(port, () => console.log(`listening on ${port}.`));

app.on("error", e => {
  if (e.code.toLowerCase() === "eaddrinuse")
    app.listen(port + 1, () => console.log(`listening on ${port + 1}`));
});
