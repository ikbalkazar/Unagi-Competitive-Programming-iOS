import json,httplib,urllib

for i in xrange(10):

  connection = httplib.HTTPSConnection('api.parse.com', 443)

  connection.connect()

  connection.request('POST', '/1/functions/CodeforcesUrlFix', json.dumps({
      "limit" : 1000,
      "skip": i * 1000
    }), {
       "X-Parse-Application-Id": "8xMwvCqficeHwkS7Ag5PQWdlw1q91ujGcXVRgUnG",
       "X-Parse-REST-API-Key": "utzFK6Be6yOJBeNF6KoeJIsSONxfnLoZIeyQuopK",
       "Content-Type": "application/json"
     })

  result = json.loads(connection.getresponse().read())

  print result

    