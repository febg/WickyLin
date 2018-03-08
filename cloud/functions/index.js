const functions = require('firebase-functions');
var request = require('request');
const webhook = ""; // :)

// Free Plan this function will not work
exports.passedTest = functions.database.ref('/Word').onCreate((event) => {
  var message = {
    text: "伟琳刚刚背完了今天的单词"
  };
  request({
    url: webhook,
    method: "POST",
    json: true,
    body: message
  }, (error, response, body) => {
    if (error === null || error === undefined) {
      return console.log("Lin passed a test");
    } else {
      return console.log(error);
    }
  });
});