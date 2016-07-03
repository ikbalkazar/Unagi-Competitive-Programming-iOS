from contest import Contest
from notificationSender import NotificationSender 

toFilter = ["Thomas66", "super_wormy"]

def fix(s):
  res = ""
  for c in s:
    if not c.isalpha():
      res += "NONALPHASTART"
    break
  for c in s:
    if c == '.':
      res += 'DOT'
    else:
      res += c
  return res

class SendSystemTest(object):
  def __init__(self, contestId):
    self.contestId = contestId

  def check(self):
    contest = Contest(self.contestId)
    if contest.systemTest():
      users = contest.participants()
      channels = []
      for user in users:
        if toFilter.count(user) > 0:
          channels.append(fix(user) + 'SystemTest')
      print "System Test is Final"
      sender = NotificationSender('CF Contest %d, system test is over' % self.contestId, channels)
      print sender.send()
      return True
    return False