import json
import os

os.makedirs("assets/puzzles", exist_ok=True)

# 1. Animals
animals = []
animal_data = [
    ("anim_01", "easy", "King of the Savanna: African Lion", "Reassemble the real photo of the apex predator known for its majestic mane and pride leadership.", ["lion", "african lion"], "Lion", "Panthera leo is a social felid apex predator native to sub-Saharan Africa.", "assets/images/animals/lion.png"),
    ("anim_02", "easy", "Apex Predator: Bengal Tiger", "Reassemble the real photographic portrait of the largest striped felid in Asia.", ["tiger", "bengal tiger"], "Tiger", "Panthera tigris is an apex predator distinguished by dark vertical stripes on reddish-orange fur.", "assets/images/animals/tiger.png"),
    ("anim_03", "medium", "Egg-Laying Marvel", "I am an Australian semi-aquatic mammal with a beaver-like tail and duck-like bill that lays eggs. Who am I?", ["platypus", "duck-billed platypus"], "Platypus", "Monotremes like the platypus lay eggs and have electrolocation in their bill.", "assets/images/animals/platypus.png"),
    ("anim_04", "medium", "Master of Disguise", "I am a marine mollusk with three hearts, blue blood, and 8 flexible limbs. Who am I?", ["octopus"], "Octopus", "Cephalopods possess three hearts, copper-based hemocyanin blood, and 8 arms.", "assets/images/animals/octopus.png"),
]
for p_id, diff, title, q, answers, ans_name, exp, img_path in animal_data:
    animals.append({
        "id": p_id,
        "category": "animals",
        "title": title,
        "description": q,
        "difficulty": diff,
        "puzzle_data": {"question": q, "target_name": ans_name, "image_path": img_path},
        "valid_answers": answers,
        "hint_ladder": {
            "gentle": "Observe the color patterns, fur texture, and anatomical features of the real photo.",
            "guided": f"This apex creature is known for {exp.split()[0]} and belongs to the genus Panthera.",
            "strong": f"The answer starts with '{ans_name[0]}' and has {len(ans_name)} letters.",
            "full_solution": ans_name
        },
        "explanation": exp,
        "estimated_seconds": 45
    })

with open("assets/puzzles/animals.json", "w") as f:
    json.dump(animals, f, indent=2)

# 2. Birds
birds = []
bird_data = [
    ("bird_01", "easy", "Apex Aviator: Bald Eagle", "Reassemble the real photograph of North America's iconic sea eagle with a snowy white head and yellow beak.", ["eagle", "bald eagle"], "Bald Eagle", "Haliaeetus leucocephalus is a sea eagle found in North America with powerful talons and a massive wingspan.", "assets/images/birds/eagle.png"),
    ("bird_02", "easy", "Feathered Splendor: Indian Peacock", "Reassemble the real photograph of the resplendent bird famous for iridescent train feathers and eye-spots.", ["peacock", "indian peacock", "peafowl"], "Peacock", "Pavo cristatus possesses iridescent blue-green plumage and elongated upper-tail coverts bearing eye-spots.", "assets/images/birds/peacock.png"),
    ("bird_03", "medium", "Speed Sovereign: Peregrine Falcon", "I am the fastest animal on Earth, reaching over 240 mph during hunting stoops. Who am I?", ["peregrine falcon", "falcon"], "Peregrine Falcon", "The peregrine falcon achieves terminal dive velocity through aerodynamic tucks.", "assets/images/birds/falcon.png"),
    ("bird_04", "medium", "Urban Tool User", "I am a corvid with intelligence matching a 7-year-old child, capable of remembering human faces and making hooks. Who am I?", ["crow", "raven", "new caledonian crow"], "Crow", "Corvids demonstrate multi-step causal reasoning and episodic-like memory.", "assets/images/birds/crow.png"),
]
for p_id, diff, title, q, answers, ans_name, exp, img_path in bird_data:
    birds.append({
        "id": p_id,
        "category": "birds",
        "title": title,
        "description": q,
        "difficulty": diff,
        "puzzle_data": {"question": q, "target_name": ans_name, "image_path": img_path},
        "valid_answers": answers,
        "hint_ladder": {
            "gentle": "Consider the aerodynamic or physical trait mentioned in the visual clue.",
            "guided": f"This avian species is notable for {exp.split()[0]}.",
            "strong": f"The answer begins with '{ans_name[0]}'.",
            "full_solution": ans_name
        },
        "explanation": exp,
        "estimated_seconds": 45
    })
with open("assets/puzzles/birds.json", "w") as f:
    json.dump(birds, f, indent=2)

# 3. General Knowledge (GK)
gk = []
gk_data = [
    ("gk_01", "easy", "World Heritage: The Ivory White Mausoleum", "Reassemble the iconic marble mausoleum built on the Yamuna river in Agra.", ["taj mahal"], "Taj Mahal", "The Taj Mahal is an ivory-white marble mausoleum on the south bank of the Yamuna river.", "assets/images/gk/taj_mahal.png"),
    ("gk_02", "easy", "Cosmic Architecture: The Solar System", "Assemble the planetary system comprising the Sun and gravitationally bound orbiting bodies.", ["solar system"], "Solar System", "The Solar System formed 4.6 billion years ago from the gravitational collapse of a giant interstellar molecular cloud.", "assets/images/gk/solar_system.png"),
    ("gk_03", "medium", "Particle Physics Milestone", "Which subatomic boson was confirmed experimentally at CERN in 2012, responsible for imparting mass?", ["higgs boson", "higgs"], "Higgs Boson", "The Higgs boson confirms the Higgs mechanism which gives mass to fundamental particles.", None),
    ("gk_04", "medium", "Orbital Equilibrium Points", "What term describes the specific equilibrium points in space where gravitational forces of two bodies balance centrifugal force?", ["lagrange points", "lagrange"], "Lagrange Points", "There are 5 Lagrange points (L1 to L5) where satellites like JWST maintain stationary relative positions.", None),
]
for p_id, diff, title, q, answers, ans_name, exp, img_path in gk_data:
    p_data = {"question": q, "target_name": ans_name}
    if img_path:
        p_data["image_path"] = img_path
    gk.append({
        "id": p_id,
        "category": "gk",
        "title": title,
        "description": q,
        "difficulty": diff,
        "puzzle_data": p_data,
        "valid_answers": answers,
        "hint_ladder": {
            "gentle": "Observe the architectural landmarks and physical laws.",
            "guided": f"The answer relates to {exp.split()[0]}.",
            "strong": f"The answer starts with '{ans_name[0]}'.",
            "full_solution": ans_name
        },
        "explanation": exp,
        "estimated_seconds": 60
    })
with open("assets/puzzles/gk.json", "w") as f:
    json.dump(gk, f, indent=2)

# 4. Cryptography
crypto = []
crypto_data = [
    ("crypt_01", "easy", "Caesar Shift +3", "Decode the message shifted by +3: 'KHOOR ZRUOG'", ["hello world"], "HELLO WORLD", "Caesar cipher with shift k=3: K->H, H->E, O->L, R->O."),
    ("crypt_02", "easy", "Rot13 Enigma", "Decode ROT13 ciphertext: 'CHMMYRIREFR'", ["puzzleverse"], "PUZZLEVERSE", "ROT13 rotates alphabetic characters by 13 positions (C->P, H->U)."),
    ("crypt_03", "medium", "Reverse Mirror Cipher", "Decode the mirrored string: 'EVITCERETNI ELZZUP'", ["interactive puzzle"], "INTERACTIVE PUZZLE", "Reversing the entire string character-by-character reveals the secret message."),
    ("crypt_04", "hard", "Atbash Ancient Code", "Decipher with Hebrew Atbash (A<->Z, B<->Y): 'TLTFOVKVIHV'", ["puzzleverse"], "PUZZLEVERSE", "Atbash maps the 1st letter to 26th, 2nd to 25th: T->P, L->U, G->T, F->U..."),
]
for p_id, diff, title, q, answers, ans_name, exp in crypto_data:
    crypto.append({
        "id": p_id,
        "category": "cryptography",
        "title": title,
        "description": q,
        "difficulty": diff,
        "puzzle_data": {"question": q, "target_name": ans_name},
        "valid_answers": answers,
        "hint_ladder": {
            "gentle": "Observe the substitution pattern or character shifts.",
            "guided": "Invert or shift the characters according to the cipher rule.",
            "strong": f"The first word of the solution is '{ans_name.split()[0]}'.",
            "full_solution": ans_name
        },
        "explanation": exp,
        "estimated_seconds": 60
    })
with open("assets/puzzles/cryptography.json", "w") as f:
    json.dump(crypto, f, indent=2)

# 5. Logic Reasoning
logic = []
logic_data = [
    ("log_01", "easy", "Knights and Knaves", "Person A says: 'Both of us are Knaves (liars)'. Can Person A be a Knight (truth-teller)? Answer Yes or No.", ["no"], "No", "If A were a Knight, their statement would be true, meaning A is a knave—a contradiction. Hence A is a Knave telling a false compound statement."),
    ("log_02", "medium", "Three Boxes", "You have three boxes: [Apples], [Oranges], [Apples and Oranges]. Every box is labeled incorrectly. You draw one fruit from the box labeled [Apples and Oranges] and it is an Apple. What does the box labeled [Oranges] contain?", ["apples and oranges", "both"], "Apples and Oranges", "Since all labels are incorrect, the [Apples and Oranges] box must be purely Apples. The box labeled [Apples] cannot be Apples, so it must be Oranges. Thus the box labeled [Oranges] must be Apples and Oranges."),
    ("log_03", "hard", "The Island of Foreheads", "Three logicians sit in a circle, each wearing a red or blue hat. Each sees the other two hats but not their own. They are told at least one hat is red. All three say 'I do not know my hat color' on round 1. In round 2, all announce their hat color. What color are all three hats?", ["red"], "Red", "If there were 1 red hat, that person would deduce immediately on round 1. If 2 red hats, both would deduce on round 2. Because all 3 hesitated on round 1 and solved on round 2, all 3 must be wearing Red hats."),
]
for p_id, diff, title, q, answers, ans_name, exp in logic_data:
    logic.append({
        "id": p_id,
        "category": "logic",
        "title": title,
        "description": q,
        "difficulty": diff,
        "puzzle_data": {"question": q, "target_name": ans_name},
        "valid_answers": answers,
        "hint_ladder": {
            "gentle": "Break the propositions down into truth tables or case deductions.",
            "guided": "Eliminate cases where a participant would have made an earlier contradiction.",
            "strong": f"The deduction directly leads to: '{ans_name}'.",
            "full_solution": ans_name
        },
        "explanation": exp,
        "estimated_seconds": 90
    })
with open("assets/puzzles/logic.json", "w") as f:
    json.dump(logic, f, indent=2)

# 6. Detective Mysteries
detective = []
detective_data = [
    ("det_01", "easy", "The Midnight Rain", "Victim Lord Ashford was found murdered in his gazebo at 1 AM. Suspect John claimed he was strolling in the gazebo gardens without an umbrella. The meteorological log showed continuous torrential rain from 12 AM to 2 AM. When arrested at 1:15 AM, John's jacket and shoes were completely dry. Who is lying?", ["john"], "John", "John claimed to be strolling in the garden during a 2-hour torrential rain without an umbrella, yet was found completely dry minutes later."),
    ("det_02", "medium", "The Frozen Clock", "A collector was shot in his study. The grandfather clock was shattered by a stray bullet at 10:15 PM. Suspect Arthur has an alibi until 10:30 PM. However, forensics noted the pendulum was detached and held by a magnet placed inside before the bullet hit. What was falsified?", ["time of death", "the time", "alibi", "clock time"], "Time of death", "The perpetrator staged the broken clock with a magnet prior to 10:15 PM to create a synthetic time-stamp and fabricate an alibi."),
    ("det_03", "hard", "The Sealed Wine Vault", "Baron Vance was poisoned in a locked wine vault. The wine bottle was opened in front of both the Baron and his guest Roger. Both drank from the same bottle with two identical glasses poured by Roger. Roger remained unharmed while the Baron died of cyanide. What held the poison?", ["ice", "the glass", "ice cubes", "his glass"], "Ice cubes", "The poison was frozen inside the ice cubes in the Baron's glass. As the ice melted into the wine, the cyanide dissolved, leaving the unaffected guest unharmed."),
]
for p_id, diff, title, q, answers, ans_name, exp in detective_data:
    detective.append({
        "id": p_id,
        "category": "detective",
        "title": title,
        "description": q,
        "difficulty": diff,
        "puzzle_data": {"question": q, "target_name": ans_name},
        "valid_answers": answers,
        "hint_ladder": {
            "gentle": "Look for physical inconsistencies between physical evidence and suspect claims.",
            "guided": "Inspect what was consumed or interacted with uniquely by the victim.",
            "strong": f"Focus on: '{ans_name}'.",
            "full_solution": ans_name
        },
        "explanation": exp,
        "estimated_seconds": 90
    })
with open("assets/puzzles/detective.json", "w") as f:
    json.dump(detective, f, indent=2)

# 7. Chess Tactics
chess = []
chess_data = [
    ("chess_01", "easy", "Back Rank Mate", "White has Queen on d8, Black King on g8 with pawns on f7, g7, h7. Black King cannot move. White Queen delivers: 'Qxd8#'. What tactical motif is this?", ["back rank mate", "back rank"], "Back Rank Mate", "The back rank mate occurs when a king is trapped behind a shield of friendly pawns with no escape square."),
    ("chess_02", "medium", "Smothered Mate Pattern", "White Knight moves to f7, checking the Black King surrounded by friendly pieces with no open flight squares. What is this mate called?", ["smothered mate", "smothered"], "Smothered Mate", "A smothered mate occurs when a knight attacks an enemy king that is unable to escape because all adjacent squares are occupied by its own friendly pieces."),
    ("chess_03", "hard", "The Greek Gift Sacrifice", "White sacrifices a Bishop on h7 (Bxh7+) followed by Ng5+ and Qh5 to launch a decisive attack against the castled black king. What is the traditional name of this sacrificial motif?", ["greek gift", "greek gift sacrifice"], "Greek Gift Sacrifice", "The classical Bishop sacrifice on h7 strips the king's defensive pawn cover and opens mating nets via Ng5 and Qh5."),
]
for p_id, diff, title, q, answers, ans_name, exp in chess_data:
    chess.append({
        "id": p_id,
        "category": "chess",
        "title": title,
        "description": q,
        "difficulty": diff,
        "puzzle_data": {"question": q, "target_name": ans_name},
        "valid_answers": answers,
        "hint_ladder": {
            "gentle": "Think of recognized tactical attacking motifs in classical chess theory.",
            "guided": "The term describes the geometric trap or historical sacrificial name.",
            "strong": f"The tactical term begins with '{ans_name[0]}'.",
            "full_solution": ans_name
        },
        "explanation": exp,
        "estimated_seconds": 60
    })
with open("assets/puzzles/chess.json", "w") as f:
    json.dump(chess, f, indent=2)

# 8. Word Puzzles
words = []
words_data = [
    ("word_01", "easy", "Anagram Master", "Rearrange the letters 'SILENT' to form another English word meaning to pay attention to sound.", ["listen"], "LISTEN", "LISTEN is an exact anagram of SILENT."),
    ("word_02", "medium", "Word Ladder: COLD to WARM", "Transform COLD into WARM in 4 steps (change 1 letter per step: COLD -> CORD -> CARD -> WARD -> WARM). What is the 3rd word in this ladder?", ["card"], "CARD", "Legal English words sequence: COLD (start) -> CORD -> CARD -> WARD -> WARM (goal)."),
    ("word_03", "hard", "Palindrome Riddle", "What 7-letter palindromic word describes a rotational speed detector in aircraft and racing cars?", ["rotator"], "ROTATOR", "R-O-T-A-T-O-R is spelled identically forward and backward."),
]
for p_id, diff, title, q, answers, ans_name, exp in words_data:
    words.append({
        "id": p_id,
        "category": "words",
        "title": title,
        "description": q,
        "difficulty": diff,
        "puzzle_data": {"question": q, "target_name": ans_name},
        "valid_answers": answers,
        "hint_ladder": {
            "gentle": "Look at the letter arrangements and word symmetries.",
            "guided": f"The answer contains {len(ans_name)} letters.",
            "strong": f"Starts with '{ans_name[0]}' and ends with '{ans_name[-1]}'.",
            "full_solution": ans_name
        },
        "explanation": exp,
        "estimated_seconds": 45
    })
with open("assets/puzzles/words.json", "w") as f:
    json.dump(words, f, indent=2)

print("Generated seed puzzles successfully!")
