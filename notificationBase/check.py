from sendSystemTest import SendSystemTest
from sendRating import SendRating

import sys

assert len(sys.argv) >= 2

contestId = int(sys.argv[1])

sysTestSender = SendSystemTest(contestId)

while True:
  if sysTestSender.check():
    print "System Test Notifications Sent"
    break

ratingSender = SendRating(contestId)

while True:
  print "Trying..."
  if ratingSender.check():
    print "Rating Notifications Sent"
    break

