from contest import Contest
from notificationSender import NotificationSender 

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

class SendRating(object):
  def __init__(self, contestId, users):
    self.contestId = contestId
    self.toFilter = users

  def check(self):
    contest = Contest(self.contestId)
    if contest.ratingChanges():
      users = contest.participants()
      channels = []
      for user in users:
        if self.toFilter.count(user) > 0:
          print "Will send to ... " + user
          channels.append(fix(user) + 'Rating')
      print "Ratings are out!"
      sender = NotificationSender('CF Contest %d, Ratings are updated!' % self.contestId, channels)
      print sender.send()
      return True
    return False