from sklearn import linear_model
import random

X = [[random.randrange(10), random.randrange(10), random.randrange(10)] for i in xrange(5)]

#print X

y = []
for r in X:
  y.append(r[0] * r[1] * r[2])

#print y

clf = linear_model.Ridge(alpha = 0.001)

print clf.fit(X, y)

print clf.predict([[4, 2, 5]])