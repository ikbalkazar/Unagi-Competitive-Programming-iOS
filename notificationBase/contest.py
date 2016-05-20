import httplib, json, urllib2  

def getPage(url):
  req = urllib2.Request(url)
  try:
    response = urllib2.urlopen(req)
    page = response.read()
    res = json.loads(page)
    return res
  except:
    return "ERROR"

class Contest(object): 
  def __init__(self, contestId):
    self.contestId = contestId

  def systemTest(self):
    res = getPage('http://codeforces.com/api/contest.list')
    contests = res["result"]
    for contest in contests:
      if contest["id"] == self.contestId:
        if contest["phase"] == "FINISHED":
          return True
    return False

  def ratingChanges(self):
    url = 'http://codeforces.com/api/contest.ratingChanges?contestId=' + str(self.contestId)
    res = getPage(url)
    if res == "ERROR":
      return False
    if res["status"] == 'OK':
      return True
    return False    

  def participants(self):
    res = getPage('http://codeforces.com/api/contest.standings?contestId=' + str(self.contestId) + "&showUnofficial=true")
    if res["status"] != "OK":
      return []
    ans = []
    resRows = res["result"]["rows"]
    for row in resRows:
      ans.append(row["party"]["members"][0]["handle"])
    return ans