import urllib, urllib2, httplib

contestId = input()
request = urllib2.Request("http://codeforces.com/contest/%d/status" % contestId)
response = urllib2.urlopen(request)
htmlFile = str(response.read())

if htmlFile.index("Finished") >= 0:
  print "Finished"
