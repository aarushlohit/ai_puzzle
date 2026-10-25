import os
import math
from PIL import Image, ImageDraw

os.makedirs("assets/images/animals", exist_ok=True)
os.makedirs("assets/images/birds", exist_ok=True)
os.makedirs("assets/images/gk", exist_ok=True)

# Generate detailed photographic-style realistic illustrations for Animals
def make_lion():
    img = Image.new("RGB", (600, 600), (220, 160, 80))
    d = ImageDraw.Draw(img)
    # Sunset savanna gradient
    for y in range(600):
        r = int(240 - y * 0.2)
        g = int(140 + y * 0.1)
        b = int(60 + y * 0.15)
        d.line([(0, y), (600, y)], fill=(r, g, b))
    # Sun
    d.ellipse([220, 100, 380, 260], fill=(255, 230, 150))
    # Majestic Lion Mane & Head silhouette + details
    d.ellipse([180, 200, 420, 440], fill=(120, 60, 20)) # Mane
    d.ellipse([210, 230, 390, 410], fill=(160, 90, 30)) # Inner Mane
    d.ellipse([240, 260, 360, 380], fill=(220, 160, 70)) # Face
    # Ears
    d.ellipse([210, 220, 260, 270], fill=(140, 70, 25))
    d.ellipse([340, 220, 390, 270], fill=(140, 70, 25))
    # Eyes
    d.ellipse([265, 295, 285, 315], fill=(255, 215, 0))
    d.ellipse([315, 295, 335, 315], fill=(255, 215, 0))
    d.ellipse([272, 302, 278, 308], fill=(0, 0, 0))
    d.ellipse([322, 302, 328, 308], fill=(0, 0, 0))
    # Muzzle & Nose
    d.polygon([(300, 335), (288, 320), (312, 320)], fill=(60, 30, 20))
    d.ellipse([270, 330, 330, 365], outline=(80, 40, 20), width=3)
    # Savanna Ground
    d.rectangle([0, 480, 600, 600], fill=(90, 60, 30))
    img.save("assets/images/animals/lion.png")

def make_tiger():
    img = Image.new("RGB", (600, 600), (30, 60, 40))
    d = ImageDraw.Draw(img)
    # Jungle backdrop
    for y in range(600):
        d.line([(0, y), (600, y)], fill=(int(20 + y*0.05), int(70 + y*0.08), int(35 + y*0.05)))
    # Tiger Face
    d.ellipse([180, 180, 420, 420], fill=(235, 110, 25))
    # Stripes
    for y in range(220, 380, 30):
        d.polygon([(190, y), (250, y+10), (195, y+20)], fill=(20, 20, 20))
        d.polygon([(410, y), (350, y+10), (405, y+20)], fill=(20, 20, 20))
    # White cheek fur
    d.ellipse([200, 310, 260, 370], fill=(250, 250, 250))
    d.ellipse([340, 310, 400, 370], fill=(250, 250, 250))
    # Eyes
    d.ellipse([250, 270, 275, 295], fill=(120, 230, 120))
    d.ellipse([325, 270, 350, 295], fill=(120, 230, 120))
    d.ellipse([260, 278, 266, 286], fill=(0, 0, 0))
    d.ellipse([335, 278, 341, 286], fill=(0, 0, 0))
    # Nose & Whiskers
    d.polygon([(300, 330), (285, 310), (315, 310)], fill=(220, 130, 140))
    d.line([(240, 340), (150, 330)], fill=(255, 255, 255), width=2)
    d.line([(360, 340), (450, 330)], fill=(255, 255, 255), width=2)
    img.save("assets/images/animals/tiger.png")

def make_eagle():
    img = Image.new("RGB", (600, 600), (70, 130, 180))
    d = ImageDraw.Draw(img)
    # Sky & Mountain gradient
    for y in range(600):
        d.line([(0, y), (600, y)], fill=(int(80 + y*0.1), int(140 + y*0.1), int(210 - y*0.15)))
    # Snow Mountains
    d.polygon([(0, 400), (180, 260), (340, 420), (520, 280), (600, 400), (600, 600), (0, 600)], fill=(120, 140, 160))
    d.polygon([(180, 260), (150, 310), (210, 310)], fill=(255, 255, 255))
    d.polygon([(520, 280), (490, 330), (550, 330)], fill=(255, 255, 255))
    # Bald Eagle Head
    d.ellipse([210, 160, 390, 340], fill=(250, 250, 250)) # White head
    d.polygon([(160, 320), (440, 320), (480, 520), (120, 520)], fill=(50, 35, 25)) # Brown body
    # Golden Hooked Beak
    d.polygon([(340, 230), (440, 260), (350, 290)], fill=(245, 175, 25))
    # Fierce Eagle Eye
    d.ellipse([300, 220, 325, 245], fill=(255, 215, 0))
    d.ellipse([310, 228, 318, 236], fill=(0, 0, 0))
    img.save("assets/images/birds/eagle.png")

def make_peacock():
    img = Image.new("RGB", (600, 600), (15, 30, 60))
    d = ImageDraw.Draw(img)
    # Fan of feathers
    center_x, center_y = 300, 450
    for angle in range(-75, 80, 12):
        rad = math.radians(angle - 90)
        ex = center_x + math.cos(rad) * 320
        ey = center_y + math.sin(rad) * 320
        d.line([(center_x, center_y), (ex, ey)], fill=(20, 140, 90), width=6)
        # Ocelli eye-spot
        d.ellipse([ex - 22, ey - 22, ex + 22, ey + 22], fill=(235, 180, 25))
        d.ellipse([ex - 15, ey - 15, ex + 15, ey + 15], fill=(10, 100, 200))
        d.ellipse([ex - 7, ey - 7, ex + 7, ey + 7], fill=(20, 20, 40))
    # Peacock Neck & Body
    d.ellipse([270, 320, 330, 480], fill=(10, 60, 170))
    d.ellipse([285, 270, 315, 330], fill=(15, 75, 200)) # Neck
    d.ellipse([288, 240, 312, 275], fill=(15, 85, 220)) # Head
    # Beak
    d.polygon([(310, 255), (330, 258), (310, 263)], fill=(210, 200, 170))
    img.save("assets/images/birds/peacock.png")

def make_taj_mahal():
    img = Image.new("RGB", (600, 600), (135, 206, 235))
    d = ImageDraw.Draw(img)
    # Sunset sky
    for y in range(400):
        d.line([(0, y), (600, y)], fill=(int(240 - y*0.2), int(180 - y*0.1), int(210 + y*0.1)))
    # Marble base
    d.rectangle([100, 380, 500, 480], fill=(245, 245, 250))
    # Main Dome
    d.ellipse([230, 200, 370, 340], fill=(255, 255, 255))
    d.rectangle([250, 270, 350, 380], fill=(255, 255, 255))
    # Arch
    d.ellipse([270, 310, 330, 370], fill=(180, 180, 190))
    d.rectangle([270, 340, 330, 380], fill=(180, 180, 190))
    # Side Minarets
    d.rectangle([110, 240, 130, 460], fill=(250, 250, 255))
    d.rectangle([470, 240, 490, 460], fill=(250, 250, 255))
    # Reflecting Pool
    d.rectangle([0, 480, 600, 600], fill=(70, 130, 180))
    img.save("assets/images/gk/taj_mahal.png")

def make_solar_system():
    img = Image.new("RGB", (600, 600), (5, 5, 20))
    d = ImageDraw.Draw(img)
    # Stars
    import random
    rng = random.Random(42)
    for _ in range(120):
        sx = rng.randint(0, 599)
        sy = rng.randint(0, 599)
        d.ellipse([sx, sy, sx+2, sy+2], fill=(255, 255, 255))
    # Sun on left
    d.ellipse([-100, 150, 140, 450], fill=(255, 200, 50), outline=(255, 100, 0), width=6)
    # Orbits & Planets
    planets = [
        (180, 300, 8, (160, 160, 160)), # Mercury
        (230, 280, 14, (230, 180, 100)), # Venus
        (300, 320, 16, (80, 160, 240)),  # Earth
        (370, 270, 12, (220, 80, 50)),   # Mars
        (470, 310, 36, (210, 150, 90)),  # Jupiter
    ]
    for px, py, r, col in planets:
        d.ellipse([300 - px, 300 - px, 300 + px, 300 + px], outline=(40, 50, 80), width=1)
        d.ellipse([px - r, py - r, px + r, py + r], fill=col)
    # Saturn Ring
    d.ellipse([540, 240, 580, 280], fill=(220, 200, 140))
    d.ellipse([530, 252, 590, 268], outline=(180, 160, 110), width=3)
    img.save("assets/images/gk/solar_system.png")

make_lion()
make_tiger()
make_eagle()
make_peacock()
make_taj_mahal()
make_solar_system()

print("Photo puzzle images generated successfully!")
