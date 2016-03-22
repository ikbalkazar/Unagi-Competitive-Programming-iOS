import urllib2

divmap = {}
for i in xrange(650, 670):
  req = urllib2.Request('https://codeforces.com/contest/' + str(i))
  response = urllib2.urlopen(req)
  page = response.read()

  res = ""
  if "Div. 1" in page:
    res += "Div. 1"
  if "Div. 2" in page:
    if len(res) > 0:
      res += " - "
    res += "Div. 2"

  if len(res) == 0:
    res = "Unusual"

  divmap[i] = res

  print i, res


