import json,httplib,urllib,urllib2

def queryProblem(url):
  connection = httplib.HTTPSConnection('api.parse.com', 443)

  params = urllib.urlencode({"where":json.dumps({
         "url": url,
       })})

  connection.connect()
  connection.request('GET', '/1/classes/Problems?%s' % params, '', {
         "X-Parse-Application-Id": "8xMwvCqficeHwkS7Ag5PQWdlw1q91ujGcXVRgUnG",
         "X-Parse-REST-API-Key": "utzFK6Be6yOJBeNF6KoeJIsSONxfnLoZIeyQuopK"
       })

  result = json.loads(connection.getresponse().read())
  return result

def getProblems():
  request = urllib2.Request("http://codeforces.com/api/problemset.problems")
  response = urllib2.urlopen(request)
  result = response.read()
  result = json.loads(result)
  problems = []
  for problem in result["result"]["problems"]:
    aUrl = "https://codeforces.com/problemset/problem/" + str(problem["contestId"]) + "/" + problem["index"]
    problems.append({"url":aUrl, "data":problem})
  return problems

def addProblem(url, apiData):
  connection = httplib.HTTPSConnection('api.parse.com', 443)
  connection.connect()
  connection.request('POST', '/1/classes/Problems', json.dumps({
          "name": apiData["name"],
          "url": url,
          "websiteId": "Codeforces",
          "tags": apiData["tags"]
       }), {
         "X-Parse-Application-Id": "8xMwvCqficeHwkS7Ag5PQWdlw1q91ujGcXVRgUnG",
         "X-Parse-REST-API-Key": "utzFK6Be6yOJBeNF6KoeJIsSONxfnLoZIeyQuopK",
         "Content-Type": "application/json"
       })
  results = json.loads(connection.getresponse().read())
  return results

problems = getProblems()

print queryProblem("https://www.codeforces.com/problemset/problem/555/C")
asdasd
for problem in problems:
  aUrl = problem["url"]
  dataBaseRes = queryProblem(aUrl)
  print dataBaseRes
  if len(dataBaseRes["results"]) == 0:
    print "Adding...  " + aUrl 
    print addProblem(aUrl, problem["data"])