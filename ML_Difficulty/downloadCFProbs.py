import urllib2, httplib, urllib, json

connection = httplib.HTTPSConnection('api.parse.com', 443)

data = []

for it in xrange(3):

  params = urllib.urlencode({"limit":1000, "skip": it * 1000})

  connection.connect()

  connection.request('GET', '/1/classes/Problems?%s' % params, json.dumps({
      "websiteId": "Codeforces"
    }), {
       "X-Parse-Application-Id": "8xMwvCqficeHwkS7Ag5PQWdlw1q91ujGcXVRgUnG",
       "X-Parse-REST-API-Key": "utzFK6Be6yOJBeNF6KoeJIsSONxfnLoZIeyQuopK",
       "Content-Type": "application/json"
     })

  result = json.loads(connection.getresponse().read())

  for problem in result["results"]:
    if "solvedBy" in problem:
      data.append([problem["solvedBy"], int(problem["contestId"])])

print len(data)
for d in data:
  print d[0], d[1]

