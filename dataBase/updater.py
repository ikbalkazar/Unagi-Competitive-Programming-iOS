import json,httplib,urllib

def getProblems():
  connection = httplib.HTTPSConnection('api.parse.com', 443)

  params = urllib.urlencode({"limit":1000,"where":json.dumps({"websiteId": {"$exists": False}})})

  connection.connect()
  
  connection.request('GET', '/1/classes/Problems?%s' % params, '', {
         "X-Parse-Application-Id": "8xMwvCqficeHwkS7Ag5PQWdlw1q91ujGcXVRgUnG",
         "X-Parse-REST-API-Key": "utzFK6Be6yOJBeNF6KoeJIsSONxfnLoZIeyQuopK"
       })
  
  return json.loads(connection.getresponse().read())

def fixProblem(problem):
  problemUrl = problem['url']

  if problemUrl.startswith('codeforces'):

    connection = httplib.HTTPSConnection('api.parse.com', 443)

    connection.connect()

    trueUrl = "https://" + problemUrl
    jsonParams = json.dumps(
      {
        "url": trueUrl
      })

    connection.request('PUT', '/1/classes/Problems/%s' % problem['objectId'], jsonParams, {
         "X-Parse-Application-Id": "8xMwvCqficeHwkS7Ag5PQWdlw1q91ujGcXVRgUnG",
         "X-Parse-REST-API-Key": "utzFK6Be6yOJBeNF6KoeJIsSONxfnLoZIeyQuopK",
         "Content-Type": "application/json"
       })
    
    result = json.loads(connection.getresponse().read())
    
    print 'fixed:', result

def addWebsiteId(problem):
  problemUrl = problem['url']
  
  websiteId = 'none'
  
  if problemUrl.startswith('codeforces') or problemUrl.startswith('https://codeforces'):
    websiteId = 'Codeforces'
  elif problemUrl.startswith('https://www.codechef'):
    websiteId = 'Codechef'
  elif problemUrl.startswith('https://community.topcoder'):
    websiteId = 'Topcoder'

  print "Website ID:", websiteId
  if websiteId != 'none':
    connection = httplib.HTTPSConnection('api.parse.com', 443)
    connection.connect()
    connection.request('PUT', '/1/classes/Problems/%s' % problem['objectId'], json.dumps({
        "websiteId": websiteId
      }), {
         "X-Parse-Application-Id": "8xMwvCqficeHwkS7Ag5PQWdlw1q91ujGcXVRgUnG",
         "X-Parse-REST-API-Key": "utzFK6Be6yOJBeNF6KoeJIsSONxfnLoZIeyQuopK",
         "Content-Type": "application/json"
       })
    result = json.loads(connection.getresponse().read())
    print 'added website id for %s' % problemUrl
    print result

for i in xrange(1000):

  problems = getProblems()

  if problems.get('error') == '':
    break

  #print json.dumps(problems, sort_keys = True, indent = 4, separators = (',', ':'))

  for problem in problems['results']:
    addWebsiteId(problem)
