import sys
import matplotlib.pyplot as plt
from mpl_toolkits.mplot3d import Axes3D  # noqa: F401

path = sys.argv[1] if len(sys.argv) > 1 else "fcc_clusters_out.txt"

points = []
with open(path, "r") as f:
    for line in f:
        x, y, z, label = map(int, line.split())
        if x == 0 and y == 0 and z == 0:
            continue
        points.append((x, y, z, label))

cluster_ids = sorted(set(p[3] for p in points))
label_map = {cid: i for i, cid in enumerate(cluster_ids)}

cmap = plt.cm.get_cmap("tab10", len(cluster_ids))
color_map = {cid: cmap(i) for i, cid in enumerate(cluster_ids)}

fig = plt.figure()
ax = fig.add_subplot(111, projection="3d")

MIN_POINTS = 20

for cid in cluster_ids:
    xs = [p[0] for p in points if p[3] == cid]
    ys = [p[1] for p in points if p[3] == cid]
    zs = [p[2] for p in points if p[3] == cid]

    if len(xs) < MIN_POINTS:
        continue

    ax.scatter(xs, ys, zs,
               color=color_map[cid],
               s=6,
               label=f"Cluster {label_map[cid]}")

ax.set_xlabel("X")
ax.set_ylabel("Y")
ax.set_zlabel("Z")
ax.set_box_aspect([1, 1, 0.3])
ax.set_title("FCC 3D Point Cloud Clustering (Real KITTI Data)")
# ax.legend()  # opțional

plt.show()
