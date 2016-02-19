import json
import urllib2

response = urllib2.urlopen('http://codeforces.com/api/problemset.problems')
html = response.read()
jsonRes = json.loads(html)

print(jsonRes["result"]["problems"][1])