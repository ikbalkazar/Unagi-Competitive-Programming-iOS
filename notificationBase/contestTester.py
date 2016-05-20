from contest import Contest

contest = Contest(675)

print contest.systemTest()
print contest.ratingChanges()

res = contest.participants()

for x in res:
  print x