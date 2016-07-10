from sendSystemTest import SendSystemTest
from sendRating import SendRating

import sys

import httplib, json

def appUsersCF():
  connection = httplib.HTTPSConnection('api.parse.com', 443)
  connection.connect()
  connection.request('GET', '/1/users', '', {
         "X-Parse-Application-Id": "8xMwvCqficeHwkS7Ag5PQWdlw1q91ujGcXVRgUnG",
         "X-Parse-REST-API-Key": "utzFK6Be6yOJBeNF6KoeJIsSONxfnLoZIeyQuopK"
       })
  result = json.loads(connection.getresponse().read())
  ids = []
  for user in result["results"]:
    if "codeforcesHandle" in user.keys():
      ids.append(user["codeforcesHandle"])
  return ids

assert len(sys.argv) >= 2

contestId = int(sys.argv[1])

toFilter = appUsersCF()

sysTestSender = SendSystemTest(contestId, toFilter)

while True:
  if sysTestSender.check():
    print "System Test Notifications Sent"
    break

ratingSender = SendRating(contestId, toFilter)

while True:
  print "Trying..."
  if ratingSender.check():
    print "Rating Notifications Sent"
    break

