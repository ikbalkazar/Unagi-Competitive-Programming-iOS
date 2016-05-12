import httplib, urllib2

#downloads the page with the given url and returns it's content in string format
def getPage(url):
  request = urllib2.Request(url)
  response = urllib2.urlopen(request)
  page = str(response.read())
  return page

#returns the codeforces nickname of the given contest's winner
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

  found = False
  at = page.index(lookFor)

  if at >= 0:
    found = True
    profileUrl = getProfileUrl(page[at:at+500])
 
  if found == False:
    raise Exception("No winner found")
  return profileUrl[9:]

contestId = input()

winner = getWinner(contestId)

print winner

contestsUrl = "http://codeforces.com/contests/with/" + winner

contestsPage = getPage(contestsUrl)

#checks whether rating information of the contest exists on the winner's profile
if contestsPage.index("/contest/%d" % contestId) >= 0:
  print "Ratings are out!!"
else:
  print "No update on ratings..."