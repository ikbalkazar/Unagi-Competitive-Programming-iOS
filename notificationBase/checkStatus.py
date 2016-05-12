import urllib, urllib2, httplib

#downloads the status page of the given contest
contestId = input()
request = urllib2.Request("http://codeforces.com/contest/%d/status" % contestId)
response = urllib2.urlopen(request)
htmlFile = str(response.read())

#looks for "Finished" to check whether system testing is 100% done.
if htmlFile.index("Finished") >= 0:
  print "Finished"
