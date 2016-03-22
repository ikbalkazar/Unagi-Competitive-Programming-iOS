import json,httplib,urllib,urllib2

divmap = {}
for i in xrange(654):
  data = map(str, raw_input().split(' '))
  divmap[int(data[0])] = ''.join(data[1:])

connection = httplib.HTTPSConnection('api.parse.com', 443)

connection.connect()

connection.request('POST', '/1/functions/CFContestSet', json.dumps({
    "tpMap": divmap
  }), {
     "X-Parse-Application-Id": "8xMwvCqficeHwkS7Ag5PQWdlw1q91ujGcXVRgUnG",
     "X-Parse-REST-API-Key": "utzFK6Be6yOJBeNF6KoeJIsSONxfnLoZIeyQuopK",
     "Content-Type": "application/json"
   })

result = json.loads(connection.getresponse().read())

print result
    