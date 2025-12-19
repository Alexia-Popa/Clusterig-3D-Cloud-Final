import sys
import numpy as np
import open3d as o3d

def load_data(file_path):
    data = np.loadtxt(file_path)
    if data.shape[1] < 4:
        raise ValueError("Fișierul trebuie să aibă 4 coloane (x, y, z, intensity)")
    return data[:, :3]  # doar coordonatele X, Y, Z

def visualize_open3d(points):
    # Creăm norul de puncte
    pcd = o3d.geometry.PointCloud()
    pcd.points = o3d.utility.Vector3dVector(points)

    # Optional: colorăm punctele în funcție de înălțime (Z)
    z = np.asarray(points)[:, 2]
    colors = plt_colormap(z)
    pcd.colors = o3d.utility.Vector3dVector(colors)

    # Vizualizare interactivă
    o3d.visualization.draw_geometries([pcd], window_name="FCC - LiDAR Point Cloud 3D")

def plt_colormap(values):
    import matplotlib.cm as cm
    import matplotlib.colors as colors
    norm = colors.Normalize(vmin=np.min(values), vmax=np.max(values))
    cmap = cm.get_cmap('viridis')
    return cmap(norm(values))[:, :3]

def main():
    if len(sys.argv) < 2:
        print("Usage: python3 plot_fcc_kitti.py fcc_clusters_out.txt")
        sys.exit(1)

    file_path = sys.argv[1]
    print(f"[INFO] Loading {file_path}...")
    points = load_data(file_path)
    print(f"[INFO] {points.shape[0]} points loaded.")
    visualize_open3d(points)

if __name__ == "__main__":
    main()
