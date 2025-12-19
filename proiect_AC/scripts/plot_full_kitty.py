#!/usr/bin/env python3
import numpy as np
import matplotlib.pyplot as plt
import argparse
import os

def load_data(file_path):
    if not os.path.exists(file_path):
        raise FileNotFoundError(f"Fișierul {file_path} nu există!")
    data = np.loadtxt(file_path)
    if data.shape[1] < 3:
        raise ValueError("Fișierul trebuie să aibă cel puțin 3 coloane (X, Y, Z).")
    return data[:, :3]

def preprocess(points):
    return points - np.mean(points, axis=0)


def classify_points(points):
    x, y, z = points[:, 0], points[:, 1], points[:, 2]
    labels = np.full(len(points), "drum", dtype=object)

    #  Drum – mai îngust, jos, pe centru
    labels[(np.abs(x) < 3) & (z < -55)] = "drum"

    #  Cale ferată – deasupra drumului, mai lată, între drum și copaci
    labels[(x > 3) & (x < 15) & (z > -45) & (z < -25)] = "cale_ferata"

    #  Tren – pe calea ferată, mai în spate
    labels[(x > 5) & (x < 14) & (y > 250) & (y < 500) & (z > -35) & (z < -25)] = "tren"

    #  Mașini – în stânga drumului, la nivelul drumului
    labels[(x < -5) & (x > -15) & (z > -55) & (z < -40)] = "masini"

    #  Clădiri – în stânga extremă, sus
    labels[(x < -18) & (z > -50)] = "cladiri"

    #  Copaci stânga – între clădiri și mașini
    labels[(x < -16) & (z > -55) & (z < -40) & (y < 300)] = "copaci"

    #  Copaci dreapta – după calea ferată, mai înalți
    labels[(x > 15) & (z > -45)] = "copaci"

    return labels





def plot_scene(points, labels, save_path=None):
    X, Y, Z = points[:, 0], -points[:, 1], points[:, 2]

    colors = {
        "drum": "black",
        "cale_ferata": "blue",
        "tren": "orange",
        "masini": "red",
        "cladiri": "purple",
        "copaci": "green",
    }

    fig = plt.figure(figsize=(13, 9))
    ax = fig.add_subplot(111, projection="3d")

    for label, color in colors.items():
        mask = labels == label
        ax.scatter(X[mask], Y[mask], Z[mask], c=color, s=3, label=label.capitalize())

    ax.set_title("Reconstrucție realistă KITTI – Drum, Cale ferată, Tren, Mașini, Clădiri, Copaci", pad=20)
    ax.set_xlabel("Stânga ↔ Dreapta (X)")
    ax.set_ylabel("Distanță înainte (Y)")
    ax.set_zlabel("Înălțime (Z)")

    #  unghi fix ca în fotografia reală KITTI
    ax.view_init(elev=10, azim=-130)

    # limite potrivite pentru proporțiile tale
    ax.set_xlim(-30, 30)
    ax.set_ylim(-150, 600)
    ax.set_zlim(-80, 20)

    ax.legend(loc="upper right", fontsize="small")
    plt.tight_layout()

    if save_path:
        plt.savefig(save_path, dpi=300)
        print(f"[OK] Imagine salvată în {save_path}")
    plt.show()

def main():
    parser = argparse.ArgumentParser(description="Plotare realistă KITTI - Drum, Cale ferată, Tren, Mașini, Clădiri, Copaci")
    parser.add_argument("input", help="Fișierul .txt cu datele LIDAR")
    parser.add_argument("--save", help="Calea unde să salveze imaginea (opțional)", default=None)
    args = parser.parse_args()

    data = load_data(args.input)
    data = preprocess(data)
    labels = classify_points(data)
    plot_scene(data, labels, save_path=args.save)

if __name__ == "__main__":
    main()
