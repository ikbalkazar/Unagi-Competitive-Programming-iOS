
// Use Parse.Cloud.define to define as many cloud functions as you want.
// For example:
Parse.Cloud.define("hello", function(request, response) {
  response.success("Hello world asdasd!");
});

Parse.Cloud.define("CodeforcesUrlFix", function(request, response) {
  var query = new Parse.Query("Problems");
  query.equalTo("websiteId", "Codeforces");
  query.startsWith("url", "code");
  query.limit(parseInt(request.params.limit, 10));
  query.skip(parseInt(request.params.skip, 10));
  query.find().then(function(results) {
    var savePromises = results.map(function(result) {
      var url = result.get("url");
      return result.save({url: "https://www." + url});
    });
    return Parse.Promise.when(savePromises);
  }).then(function() {
    response.success();
  }, function(err) {
    response.error(err);
  })
});
