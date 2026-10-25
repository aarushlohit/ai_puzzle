import urllib.request
import os
from PIL import Image

headers = {'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64)'}

targets = [
    # Animals
    ("https://upload.wikimedia.org/wikipedia/commons/9/9e/Lion_%28Panthera_leo%29_male_6y.jpg", "assets/images/animals/lion.png"),
    ("https://upload.wikimedia.org/wikipedia/commons/4/49/Panthera_tigris_tigris.jpg", "assets/images/animals/tiger.png"),
    
    # Birds
    ("https://upload.wikimedia.org/wikipedia/commons/f/fa/Bald_Eagle_%28Haliaeetus_leucocephalus%29.jpg", "assets/images/birds/eagle.png"),
    ("https://upload.wikimedia.org/wikipedia/commons/0/0c/Peacock._%28Pavo_cristatus%29%2C_%289699918900%29.jpg", "assets/images/birds/peacock.png"),
    
    # General Knowledge
    ("https://upload.wikimedia.org/wikipedia/commons/7/74/Taj_Mahal%2C_Agra%2C_India_edit2.jpg", "assets/images/gk/taj_mahal.png"),
    ("https://upload.wikimedia.org/wikipedia/commons/8/83/Solar_system.jpg", "assets/images/gk/solar_system.png"),
]

for url, dest_path in targets:
    try:
        print(f"Downloading real photo from: {url}")
        req = urllib.request.Request(url, headers=headers)
        temp_dest = dest_path + ".tmp"
        with urllib.request.urlopen(req, timeout=15) as resp, open(temp_dest, 'wb') as f:
            f.write(resp.read())
        
        # Crop square and save in high resolution (600x600)
        with Image.open(temp_dest) as img:
            img = img.convert("RGB")
            w, h = img.size
            min_side = min(w, h)
            left = (w - min_side) // 2
            top = (h - min_side) // 2
            cropped = img.crop((left, top, left + min_side, top + min_side))
            resized = cropped.resize((600, 600), Image.Resampling.LANCZOS)
            resized.save(dest_path, "PNG")
        
        if os.path.exists(temp_dest):
            os.remove(temp_dest)
        print(f"Successfully processed real photo: {dest_path}")
    except Exception as e:
        print(f"Error downloading {url}: {e}")

print("Done processing real photos!")
