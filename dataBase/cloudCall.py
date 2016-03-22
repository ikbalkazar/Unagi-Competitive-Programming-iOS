import json,httplib,urllib,urllib2

req = urllib2.Request("http://codeforces.com/api/problemset.problems")
response = urllib2.urlopen(req)
page = response.read()
content = json.loads(page);

problemStats = content["result"]["problemStatistics"]

for i in xrange(3):
  connection = httplib.HTTPSConnection('api.parse.com', 443)

  connection.connect()

  connection.request('POST', '/1/functions/CodeforcesSolverCount', json.dumps({
      "problemStats": problemStats,
      "limit": 1000,
      "skip": i * 1000
    }), {
       "X-Parse-Application-Id": "8xMwvCqficeHwkS7Ag5PQWdlw1q91ujGcXVRgUnG",
       "X-Parse-REST-API-Key": "utzFK6Be6yOJBeNF6KoeJIsSONxfnLoZIeyQuopK",
       "Content-Type": "application/json"
     })

  result = json.loads(connection.getresponse().read())

  print result

    