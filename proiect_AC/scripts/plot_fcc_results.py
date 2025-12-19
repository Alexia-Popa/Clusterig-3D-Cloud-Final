import numpy as np
import matplotlib.pyplot as plt

# --- Citire date brute ---
lidar_file = "../data/lidar_stream.txt"
points = np.loadtxt(lidar_file, dtype=float)

x, y, z = points[:, 0], points[:, 1], points[:, 2]
labels = np.zeros(len(points), dtype=int)

# --- Cladiri
mask_cladiri = (x < -20)
labels[mask_cladiri] = 4

# --- Masini
mask_masini = (x >= -19) & (x <= -10) & (z < 0)
labels[mask_masini] = 3

# --- Drum 
mask_drum = (x > -9) & (x < 5) & (z < 0)
labels[mask_drum] = 0

# --- Cale ferata
mask_cale = (x >= 6) & (x < 10) & (z < 5)
labels[mask_cale] = 1

# --- Tren 
mask_tren = (x >= 6) & (x < 10) & (y > 400)
labels[mask_tren] = 2

# --- Copaci 
mask_copaci = (x > 10) & (y > 150) & (z > -60)
labels[mask_copaci] = 5

# --- Culori + denumiri ---
mapping = {
    0: ("Drum", "black"),
    1: ("Cale ferată", "blue"),
    2: ("Tren", "orange"),
    3: ("Mașini", "red"),
    4: ("Clădiri", "purple"),
    5: ("Copaci", "green"),
}

# --- Plotare ---
fig = plt.figure(figsize=(10, 7))
ax = fig.add_subplot(111, projection='3d')

for val, (name, color) in mapping.items():
    mask = labels == val
    if np.any(mask):
        ax.scatter(x[mask], y[mask], z[mask], s=2, c=color, label=name)

ax.set_xlabel("Stânga ↔ Dreapta (X)")
ax.set_ylabel("Distanță înainte (Y)")
ax.set_zlabel("Înălțime (Z)")
ax.set_title("Reconstrucție realistă KITTI – Drum, Cale ferată, Tren, Mașini, Clădiri, Copaci")
ax.legend()
ax.view_init(elev=15, azim=-90)

plt.show()
