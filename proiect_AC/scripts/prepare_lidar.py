import numpy as np

# citim fișierul original KITTI
path = "../data/lidar_stream.txt"
print(f"[INFO] Citim fișierul: {path}")

data = np.loadtxt(path)

# selectăm doar coloanele utile (x, y, z)
if data.shape[1] >= 3:
    x, y, z = data[:, 0], data[:, 1], data[:, 2]
else:
    raise ValueError(f"Fișierul are doar {data.shape[1]} coloane, trebuie minim 3 (x y z).")

print(f"[INFO] {len(x)} puncte încărcate ({data.shape[1]} coloane detectate)")

# mapăm x,y la un grid 64x900 (range image)
rows, cols = 64, 900
row_idx = np.clip(((z - z.min()) / (z.max() - z.min()) * (rows - 1)).astype(int), 0, rows-1)
col_idx = np.clip(((x - x.min()) / (x.max() - x.min()) * (cols - 1)).astype(int), 0, cols-1)

# creăm output-ul în formatul Verilogului
out = np.column_stack([row_idx, col_idx, x, y, z])

np.savetxt("../data/lidar_stream_prepared.txt", out, fmt="%d %d %.2f %.2f %.2f")
print(f"[INFO] Fișier convertit: {len(out)} puncte → lidar_stream_prepared.txt")
