const express = require("express");
const app = express();
const port = 8000;

const greet = process.env.MY_VARIABLE
const essential = process.env.CRITICAL_THING

app.get("/", (req, res) => {
  const message = "Oops, there's been an error. Something is missing, where's that critical thing I should have?";
  if(essential) {
    res.send(`I've found all the things I need so... ${greet} from the Pipeline course app!`);
  } else {
    console.log(new Error(message))
    res.status(200).send(message);
  }
});

app.get("/healthz", (req, res) => {
  res.send("Healthy");
});

app.listen(port, () => {
  console.log(`Example app listening on port ${port}`);
});