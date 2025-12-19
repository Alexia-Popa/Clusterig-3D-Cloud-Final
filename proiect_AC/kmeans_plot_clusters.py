import matplotlib.pyplot as plt
import numpy as np
from mpl_toolkits.mplot3d import Axes3D

points = []

with open("clusters_out.txt") as f:
    for line in f:
        line = line.strip()
        if not line or not line[0].isdigit():
            continue
        x, y, z, label = map(int, line.split())
        points.append((x, y, z, label))


clusters = {}
for x, y, z, label in points:
    clusters.setdefault(label, []).append((x, y, z))


centroids = {
    label: np.mean(pts, axis=0)
    for label, pts in clusters.items()
}

# sortează centroizii (pentru culori stabile)
ordered_labels = sorted(centroids, key=lambda l: centroids[l][0])
label_map = {old: new for new, old in enumerate(ordered_labels)}

num_clusters = len(ordered_labels)

# paletă automată de culori
cmap = plt.get_cmap("tab10")   
colors = [cmap(i) for i in range(num_clusters)]

fig = plt.figure()
ax = fig.add_subplot(111, projection='3d')

for x, y, z, label in points:
    ax.scatter(
        x, y, z,
        color=colors[label_map[label]],
        s=80
    )

ax.set_xlabel("X")
ax.set_ylabel("Y")
ax.set_zlabel("Z")
ax.set_title(f"K-means clustering (HDL - K={num_clusters})")

plt.show()
