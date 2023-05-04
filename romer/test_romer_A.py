import matplotlib.pyplot as plt

As = [5]
gamma = 0.1
l = 0.8
L_A = 740
phi = 0.0001

for i in range(100):
    L_A = L_A*((11500/L_A)**0.134)
    As.append(As[-1] + (gamma * (L_A**l) * (As[-1]**phi)))

plt.plot(As)
plt.show()




