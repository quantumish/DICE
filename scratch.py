import matplotlib
matplotlib.use("Qt5Agg")
import matplotlib.pyplot as plt
import sys

thing = sys.argv[1]

files = [
    ("DICE2020", f"./original/Results_{thing}.csv"),
    ("DICE-PACE (p=1)", f"./pace/Results_{thing}.csv"),
    ("Romer", f"./romer/Results_{thing}.csv"),
]


for name, infile in files:
    lim = False
    vals = [float(x) for x in open(infile, "r").readlines()]
    lim = 10 if lim else len(vals)
    plt.plot([2015 + (10*i) for i in range(lim)], vals[:lim], label=name)

plt.legend()
plt.xlabel("Year")
plt.ylabel(thing)
plt.show()
