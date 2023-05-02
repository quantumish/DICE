vals = [float(x) for x in open("Results_Mu.csv", "r").readlines()]
deltas = []
print(len(vals))
for i in range(1, 100):
    diff = vals[i]-vals[i-1]
    print(i, diff if diff > 0 else 0.0)


