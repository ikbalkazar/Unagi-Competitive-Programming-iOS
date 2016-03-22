import json,httplib,urllib
import random

pbs = []

for i in xrange(3):
  connection = httplib.HTTPSConnection('api.parse.com', 443)

  params = urllib.urlencode({"limit":1000, "skip":i*1000, "where":json.dumps({"websiteId": "Codeforces"})})

  connection.connect()

  connection.request('GET', '/1/classes/Problems?%s' % params, json.dumps({
      "websiteId": "Codeforces"
    }), {
      "X-Parse-Application-Id": "8xMwvCqficeHwkS7Ag5PQWdlw1q91ujGcXVRgUnG",
      "X-Parse-REST-API-Key": "utzFK6Be6yOJBeNF6KoeJIsSONxfnLoZIeyQuopK"
    })

  problems = json.loads(connection.getresponse().read())  

  for problem in problems["results"]:
    pbs.append(problem["url"])

chosen = random.sample(pbs, 50)

for p in chosen:
  print p