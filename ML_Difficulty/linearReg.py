from sklearn import linear_model
from sklearn import datasets

db = datasets.load_diabetes()

print db.target
print len(db.data)
print len(db.data[0])