// Use Parse.Cloud.define to define as many cloud functions as you want.
// For example:
Parse.Cloud.define("hello", function(request, response) {
  response.success("Hello world asdasd!");
});

Parse.Cloud.define("CFContestSet", function(request, response) {
  var tpMap = request.params.tpMap;
  var query = new Parse.Query("Problems");
  query.equalTo("websiteId", "Codeforces");
  query.doesNotExist("contestType");
  query.limit(1000);
  var cnt = 0;
  query.find().then(function(results) {
      promises = results.map(function(result) {  
        var url = result.get("url");
        var parts = url.split('/');
        var cid = parts[parts.length - 2];
        var ctp = tpMap[cid];
        cnt += 1;
        return result.save({contestId: cid, contestType: ctp});
      });
      return Parse.Promise.when(promises);
  }).then(function() {
    response.success("Done = " + cnt.toString());
  }, function(err) {
    response.error(err);
  })
});

Parse.Cloud.define("CodeforcesSolverCount", function(request, response) {
  problemStats = request.params.problemStats;
  var statMap = {};
  for (var i = 0; i < problemStats.length; i++) {
    var cur = problemStats[i];
    statMap[cur.contestId.toString() + cur.index] = cur.solvedCount;
  }
  var query = new Parse.Query("Problems");
  query.equalTo("websiteId", "Codeforces");
  query.doesNotExist("solvedBy");
  query.limit(parseInt(request.params.limit, 10));
  query.skip(parseInt(request.params.skip, 10));
  query.find().then(function(results) {
    var promises = results.map(function(result) {
      var url = result.get("url");
      var parts = url.split('/');
      var contestId = parts[parts.length - 2];
      var index = parts[parts.length - 1];
      var solvedCount = statMap[contestId + index];
      return result.save({solvedBy: solvedCount});
    });
    return Parse.Promise.when(promises);
  }).then(function() {
    response.success();
  }, function(err) {
    response.error(err);
  })
});

Parse.Cloud.define("CodeforcesUrlFix", function(request, response) {
  var query = new Parse.Query("Problems");
  query.equalTo("websiteId", "Codeforces");
  query.startsWith("url", "https://codeforces");
  query.limit(parseInt(request.params.limit, 10));
  query.skip(parseInt(request.params.skip, 10));
  query.find().then(function(results) {
    var promises = results.map(function(result) {
      var url = result.get("url");
      return result.save({url: "https://www." + url.substring(8)});
    });
    return Parse.Promise.when(promises);
  }).then(function() {
    response.success();
  }, function(err) {
    response.error(err);
  })
});