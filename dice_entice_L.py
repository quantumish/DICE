import matplotlib
matplotlib.use("Qt5Agg")
import matplotlib.pyplot as plt
import math

L0_DICE = 7453
L0_ENTICE = 5743
gL0_DICE = 0.134
gL0_ENTICE = 0.146
dL = 0.2

gL = []
L_DICE = [L0_DICE]
L_ENTICE = []

for i in range(1, 100):
    L_DICE.append(L_DICE[i-1]*((11500/L_DICE[i-1])**gL0_DICE))

for i in range(100):
    gL.append((gL0_ENTICE/dL)*(1-math.exp(-dL*i)))
    L_ENTICE.append(L0_ENTICE*math.exp(gL[-1]))                

plt.plot([2015 + 10*i for i in range(100)], L_DICE, label="DICE")
plt.plot([1995 + 10*i for i in range(100)], L_ENTICE, label="ENTICE")
plt.title(f"Population growth in DICE2020 vs ENTICE (dL = {dL})")
plt.legend()
plt.xlabel("Year")
plt.ylabel("Population (millions)")
plt.show()
