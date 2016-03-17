import urllib2
import httplib
import json

def beginsWith(a, b):
  if len(a) < len(b):
    return False
  return a[:len(b)] == b

def isWhiteSpace(c):
  if c == ' ' or c == '\n':
    return True
  return False

def getName(s):
  res = ""
  biggerSeen = False
  for i in xrange(len(s)):
    if s[i] == '>':
      biggerSeen = True
    elif biggerSeen and s[i] == '<':
      break
    elif biggerSeen and not isWhiteSpace(s[i]):
      res += s[i]
  return res

def getUrl(s):
  started = False
  res = ""
  for c in s:
    if not started and c == '\"':
      started = True
      continue
    if started and c == '\"':
      break
    elif started:
      res += c
  return "https://community.topcoder.com" + res

def getTags(s):
  #print "Tags=>:", s
  res = []
  last = ""
  startSeen = False
  biggerSeen = False
  for i in xrange(len(s)):
    if beginsWith(s[i:], "statText"):
      startSeen = True
    elif startSeen and s[i] == '>':
      biggerSeen = True
    elif biggerSeen and s[i] == '<':
      break
    elif biggerSeen and not isWhiteSpace(s[i]):
      if s[i] == ',':
        res.append(last)
        last = ""
      else:
        last += s[i]
  return res

f = open('topcoderpage.html', 'r')
page = f.read()

probPref = "<A HREF=\"/stat?c=problem_statement"
authorPref = "<a href=\"/tc?module=MemberProfile"
usualPref = "<TD CLASS=\"statText\" HEIGHT=\"13\" ALIGN=\"left\">"

problemSeen = False

problemName = ""
problemUrl = ""
problemTags = []

problems = []
for i in xrange(len(page)):
  pagePart = page[i:min(i+300, len(page))]
  if beginsWith(pagePart, probPref):
    problemName = getName(pagePart)
    problemUrl = getUrl(pagePart)
    problemSeen = True
  elif problemSeen and beginsWith(pagePart, authorPref):
    problemTags = getTags(pagePart)
    problems.append([problemName, problemUrl, problemTags])
    problemName = ""
    problemUrl = ""
    problemTags = []
    problemSeen = False

connection = httplib.HTTPSConnection('api.parse.com', 443)
connection.connect()

cnt = 0
for problem in problems:  
  cnt += 1
  if cnt >= 140:
    connection.request('POST', '/1/classes/Problems', json.dumps({
           "name": problem[0],
           "url": problem[1],
           "tags": problem[2]
          }), {
           "X-Parse-Application-Id": "8xMwvCqficeHwkS7Ag5PQWdlw1q91ujGcXVRgUnG",
           "X-Parse-REST-API-Key": "utzFK6Be6yOJBeNF6KoeJIsSONxfnLoZIeyQuopK",
           "Content-Type": "application/json"
         })
    results = json.loads(connection.getresponse().read()) 
    print cnt, results