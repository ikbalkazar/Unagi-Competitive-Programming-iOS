import json
import urllib2
import httplib
 
response = urllib2.urlopen('http://codeforces.com/api/problemset.problems')
html = response.read()
jsonRes = json.loads(html)
 
jsonProblems = jsonRes["result"]["problems"]
 
connection = httplib.HTTPSConnection('api.parse.com', 443)
connection.connect()
 
cnt = 0
for problem in jsonProblems:  
  cnt += 1
  if cnt >= 1947:
    connection.request('POST', '/1/classes/Problems', json.dumps({
           "name": problem["name"],
           "tags": problem["tags"],
           "url": "codeforces.com/problemset/problem/" + str(problem["contestId"]) + "/" + problem["index"]
          }), {
           "X-Parse-Application-Id": "8xMwvCqficeHwkS7Ag5PQWdlw1q91ujGcXVRgUnG",
           "X-Parse-REST-API-Key": "utzFK6Be6yOJBeNF6KoeJIsSONxfnLoZIeyQuopK",
           "Content-Type": "application/json"
         })
    results = json.loads(connection.getresponse().read()) 
    print cnt, results
