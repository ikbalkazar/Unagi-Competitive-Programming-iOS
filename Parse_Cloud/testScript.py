import httplib, json

connection = httplib.HTTPSConnection('api.parse.com', 443)

connection.connect()

connection.request('POST', '/1/functions/codeforcesRefreshSolved', json.dumps({
    "userId": "apIjVVVlTQ",
    "codeforcesId": "hexor",
    "after": 0
  }), {
     "X-Parse-Application-Id": "8xMwvCqficeHwkS7Ag5PQWdlw1q91ujGcXVRgUnG",
     "X-Parse-REST-API-Key": "utzFK6Be6yOJBeNF6KoeJIsSONxfnLoZIeyQuopK",
     "Content-Type": "application/json"
   })

result = json.loads(connection.getresponse().read())

print json.dumps(result, sort_keys=True, indent=4)
