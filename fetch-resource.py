# A max-compatible resource fetcher for uv

import os
import sys
import zipfile
import urllib.request
import urllib.error

PRIMARY_URL = "https://releases.astral.sh/github/uv/releases/download/0.11.12/uv-x86_64-pc-windows-msvc.zip"
MIRROR_URL = "https://mirrors.ustc.edu.cn/github-release/astral-sh/uv/LatestRelease/uv-x86_64-pc-windows-msvc.zip" # UTSC only have latest mirror
TARGET_DIR = ".uv2setup"
ZIP_PATH = os.path.join(TARGET_DIR, "uv.zip")

def download(url, dest):
    def progress(block_num, block_size, total_size):
        downloaded = block_num * block_size
        if total_size > 0:
            percent = min(100, downloaded * 100 // total_size)
            sys.stdout.write("\rDownloading: %d%%" % percent)
            sys.stdout.flush()

    urllib.request.urlretrieve(url, dest, reporthook=progress)
    print("\nDownloaded from:", url)


def try_download():
    try:
        print("[1] Trying primary source: " + PRIMARY_URL)
        download(PRIMARY_URL, ZIP_PATH)
        return
    except Exception as e:
        print("\nPrimary failed:", e)

    try:
        print("[2] Trying USTC mirror: " + MIRROR_URL)
        download(MIRROR_URL, ZIP_PATH)
        return
    except Exception as e:
        print("\nMirror failed:", e)
        raise RuntimeError("Both primary and mirror download failed.")


def extract_zip():
    print("[3] Extracting...")

    with zipfile.ZipFile(ZIP_PATH, "r") as zf:
        zf.extractall(TARGET_DIR)

    print("Extract done.")


def main():
    if not os.path.exists(TARGET_DIR):
        os.makedirs(TARGET_DIR)

    try:
        try_download()
        extract_zip()

    except Exception as e:
        print("\nFatal error:", e)
        sys.exit(1)

    finally:
        if os.path.exists(ZIP_PATH):
            try:
                os.remove(ZIP_PATH)
                print("Temp file cleaned.")
            except:
                pass

    print("\nInstallation complete.")


if __name__ == "__main__":
    main()