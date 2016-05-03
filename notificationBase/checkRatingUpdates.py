import httplib, urllib2

def getPage(url):
  request = urllib2.Request(url)
  response = urllib2.urlopen(request)
  page = str(response.read())
  return page

def getWinner(contestId):

  page = getPage("http://codeforces.com/contest/%d/standings" % contestId)

  lookFor = "<td class=\"contestant-cell\" style=\"text-align:left;padding-left:1em;\">"

  def getTillQuote(s):
    res = ""
    for c in s:
      if c == '\"':
        break
      else:
        res += c
    return res

  def getProfileUrl(s):
    for i in xrange(len(s)):
      if s[i:].startswith("<a href="):
        return getTillQuote(s[i+9:])

  profileUrl = ""
  found = False

  for i in xrange(len(page)):
    if page[i:i+500].startswith(lookFor):
      profileUrl = getProfileUrl(page[i:i+500])
      found = True
      break

  assert(found)
  return profileUrl[9:]

contestId = input()

winner = getWinner(contestId)

contestsUrl = "http://codeforces.com/contests/with/" + winner

contestsPage = getPage(contestsUrl)

if contestsPage.index("/contest/%d" % contestId) >= 0:
  print "Ratings are out!!"
else:
  print "No update on ratings..."