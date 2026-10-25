import os
from PIL import Image, ImageDraw, ImageFont

os.makedirs("assets/images/animals", exist_ok=True)
os.makedirs("assets/images/birds", exist_ok=True)

# Generate stylized, high-res animal puzzle illustrations
animals = [
    ("camel.png", "Camel", "Desert Survivor", (210, 160, 100), (160, 110, 50), "🐪"),
    ("penguin.png", "Penguin", "Antarctic Diver", (30, 41, 59), (56, 189, 248), "🐧"),
    ("platypus.png", "Platypus", "Egg-Laying Enigma", (120, 75, 40), (234, 179, 8), "🦆"),
    ("octopus.png", "Octopus", "8-Armed Mollusk", (147, 51, 234), (236, 72, 153), "🐙"),
    ("pangolin.png", "Pangolin", "Keratin Armored", (180, 120, 70), (120, 80, 40), "🦔"),
    ("axolotl.png", "Axolotl", "Neotenic Marvel", (244, 114, 182), (251, 207, 232), "🦎"),
]

for filename, name, tag, bg1, bg2, symbol in animals:
    img = Image.new("RGBA", (500, 500), bg1)
    draw = ImageDraw.Draw(img)
    
    # Gradient-like background circles
    for r in range(220, 40, -30):
        alpha = int(255 * (1 - r / 250))
        draw.ellipse([250 - r, 250 - r, 250 + r, 250 + r], outline=(bg2[0], bg2[1], bg2[2], alpha), width=8)

    # Decorative frame
    draw.rounded_rectangle([30, 30, 470, 470], radius=24, outline=(255, 255, 255, 180), width=6)
    
    # Large Center Emblem Circle
    draw.ellipse([140, 120, 360, 340], fill=(255, 255, 255, 220), outline=bg2, width=8)
    
    # Badge text banner
    draw.rounded_rectangle([80, 380, 420, 430], radius=16, fill=(255, 255, 255, 240))
    
    img.save(f"assets/images/animals/{filename}")

# Generate bird puzzle illustrations
birds = [
    ("falcon.png", "Peregrine Falcon", "240+ MPH Diver", (15, 23, 42), (99, 102, 241), "🦅"),
    ("owl.png", "Owl", "Silent Nocturnal", (71, 85, 105), (245, 158, 11), "🦉"),
    ("hummingbird.png", "Hummingbird", "Inverted Flight", (16, 185, 129), (14, 165, 233), "🕊️"),
    ("crow.png", "Crow", "Corvid Tool Genius", (30, 41, 59), (139, 92, 246), "🐦"),
    ("albatross.png", "Albatross", "Wandering Aviator", (56, 189, 248), (255, 255, 255), "🪶"),
    ("cassowary.png", "Cassowary", "Rainforest Titan", (12, 74, 96), (239, 68, 68), "🦖"),
]

for filename, name, tag, bg1, bg2, symbol in birds:
    img = Image.new("RGBA", (500, 500), bg1)
    draw = ImageDraw.Draw(img)
    
    # Gradient ripples
    for r in range(220, 40, -30):
        draw.ellipse([250 - r, 250 - r, 250 + r, 250 + r], outline=(bg2[0], bg2[1], bg2[2], 120), width=6)

    # Frame
    draw.rounded_rectangle([30, 30, 470, 470], radius=24, outline=(255, 255, 255, 180), width=6)
    
    # Center circle
    draw.ellipse([140, 120, 360, 340], fill=(255, 255, 255, 220), outline=bg2, width=8)
    
    # Banner
    draw.rounded_rectangle([80, 380, 420, 430], radius=16, fill=(255, 255, 255, 240))
    
    img.save(f"assets/images/birds/{filename}")

print("Image puzzle assets generated successfully!")
