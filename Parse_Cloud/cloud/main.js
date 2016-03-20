
// Use Parse.Cloud.define to define as many cloud functions as you want.
// For example:
Parse.Cloud.define("hello", function(request, response) {
  response.success("Hello world asdasd!");
});

Parse.Cloud.define("CodeforcesSolverCount", function(request, response) {
  var query = new Parse.Query("Problems");
  query.equalTo("websiteId", "Codeforces");
  query.find({
    success: function(results) {
      var numProblemsUpdated = 0;
      
      response.success(numProblemsUpdated);
    },
    error: function() {
      response.error("Failed!");
    }
  });
});
