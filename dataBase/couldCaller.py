import json,httplib,urllib

connection = httplib.HTTPSConnection('api.parse.com', 443)

connection.connect()

connection.request('POST', '/1/functions/hello', json.dumps({
    "name" : "someone"
  }), {
     "X-Parse-Application-Id": "8xMwvCqficeHwkS7Ag5PQWdlw1q91ujGcXVRgUnG",
     "X-Parse-REST-API-Key": "utzFK6Be6yOJBeNF6KoeJIsSONxfnLoZIeyQuopK",
     "Content-Type": "application/json"
   })

result = json.loads(connection.getresponse().read())

print result

    