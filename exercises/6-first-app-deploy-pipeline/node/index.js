const express = require("express");
const app = express();
const port = 8000;

app.get("/", (req, res) => {
  res.send("Hello from the Pipeline course app!");
});

app.get("/healthz", (req, res) => {
  res.send("Healthy");
});

app.listen(port, () => {
  console.log(`Example app listening on port ${port}`);
});