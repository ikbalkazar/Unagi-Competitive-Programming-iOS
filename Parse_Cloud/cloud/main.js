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

//@param : codeforces id, parse user id
//@description: seraches solved problems of a user by codeforces api
//  adds new solved problems to the user's data base entity
Parse.Cloud.define('codeforcesRefreshSolved', function(request, response) {
  var codeforcesId = request.params.codeforcesId;
  var userId = request.params.userId;
  var problemIds = [];
  Parse.Cloud.httpRequest({
    url: 'http://codeforces.com/api/user.status?handle=' + codeforcesId
  }).then(function(httpResponse) {
    var res = JSON.parse(httpResponse.text);
    var submissions = res["result"];
    var names = [];
    for (var i = 0; i < submissions.length; i++) {
      if (submissions[i]["verdict"] == "OK") {
        var name = submissions[i]["problem"]["name"];
        names.push(name);
      }
    }

    //prevent duplication in names
    names = names.filter(function(val, index, self) {
      return self.indexOf(val) == index
    });

    var promises = [];
    for (var i = 0; i < names.length; i++) {
      var query = new Parse.Query('Problems');
      query.equalTo('websiteId', 'Codeforces');
      query.equalTo('name', names[i]);
      var promise = query.find().then(function(results) {
        problemIds.push(results[0].id);
      });
      promises.push(promise);
    }

    return Parse.Promise.when(promises);
  }).then(function() {
    Parse.Cloud.useMasterKey();
    var query = new Parse.Query('User');
    query.equalTo('objectId', userId);
    query.find(function(users) {
      var user = users[0];
      var solved = user.get('solved');
      if (!solved) {
        solved = [];
      }
      for (var i = 0; i < problemIds.length; i++) {
        solved.push(problemIds[i]);
      }

      solved = solved.filter(function(val, index, self) {
        return self.indexOf(val) == index;
      });

      return user.save({solved: solved});
    }).then(function() {
      response.success('Saved # ' + problemIds.length);
    }, function(err) {
      response(err);
    });
  }, function(err) {
    response.error(err);
  });
});

