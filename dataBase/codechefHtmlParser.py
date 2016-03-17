import urllib2
import httplib
import json

def beginsWith(a, b):
  if len(a) < len(b):
    return False
  return a[:len(b)] == b

def formatted(s):
  #print s
  first = ""
  quoteStart = False
  for i in xrange(len(s)):
    if quoteStart and s[i] == '\"':
      s = s[i+2:]
      break
    if quoteStart:
      first += s[i]    
    if s[i] == '\"':
      quoteStart = True
  #print "==>", s
  second = ""
  start = False
  for c in s:
    if start and c == '<':
      break
    if start:
      second += c
    if c == '>':
      start = True 
  return ["https://www.codechef.com" + first, second]

pageUrls = [
"https://www.codechef.com/problems/school/", 
"https://www.codechef.com/problems/easy/", 
"https://www.codechef.com/problems/medium/", 
"https://www.codechef.com/problems/hard/", 
"https://www.codechef.com/problems/challenge/"]

problems = []
for url in pageUrls:
  req = urllib2.Request('https://www.codechef.com/problems/easy/')
  response = urllib2.urlopen(req)
  page = response.read()

  for i in xrange(len(page)):
    if beginsWith(page[i:], "<table width=\"100%\" class=\"problems\">"):
      page = page[i:]
      break

  #print page

  pref = "<a href=\"/problems/"
  endPref = "<div id=\"sidebar-content\" class=\"cols-2\">"
  for i in xrange(len(page)):
    if beginsWith(page[i:], pref):
      x = i
      res = ""
      while x + 1 < len(page):
        res += page[x]
        if page[x] == '/' and page[x + 1] == 'b':
          break
        x += 1
      problems.append(formatted(res))
      print formatted(res)
    elif beginsWith(page[i:], endPref):
      break


connection = httplib.HTTPSConnection('api.parse.com', 443)
connection.connect()

cnt = 0
for problem in problems:  
  cnt += 1
  if cnt >= 0:
    connection.request('POST', '/1/classes/Problems', json.dumps({
           "name": problem[1],
           "url": problem[0]
          }), {
           "X-Parse-Application-Id": "8xMwvCqficeHwkS7Ag5PQWdlw1q91ujGcXVRgUnG",
           "X-Parse-REST-API-Key": "utzFK6Be6yOJBeNF6KoeJIsSONxfnLoZIeyQuopK",
           "Content-Type": "application/json"
         })
    results = json.loads(connection.getresponse().read()) 
    print cnt, results