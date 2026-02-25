Time,Segment,Primary Objective,Mechanics Introduced
00:00 - 02:00,The Awakening,Exit the Grand Central Terminal subway mouth into the blizzard.,"Introduction: Navigation HUD, Cold/Temperature meter, and first ""Radiation Hotzone."""
02:00 - 05:00,First Contact,Bypass a scavenger group picketing a food cache.,"Stealth: Tutorial for ""The Car Crawl."" Slink under a '64 Impala to steal ""Pristine"" Iodine."
05:00 - 08:00,The Sanctuary,"Reach the ""Theater Bus"" campsite.",Progression: The Campfire (Warmth/Decon). Loot the M3 Grease Gun from a dead Courier.
08:00 - 11:00,The Squeeze,Navigate a narrow gap between a jackknifed transit bus and a wall.,"Verticality: Tutorial for ""Bus Ledges"" to bypass a heavy MP patrol on the ground."
11:00 - 13:00,The Trigger,"An MP patrol spots you. The ""Panic Focus"" mechanic engages.","Escalation: Transition from Stealth to Combat. First use of the ""Corner Lean."""
13:00 - 15:00,Combat Peak,Survive a multi-enemy firefight to reach the Signal Tower.,"Combat: High-recoil gunplay, ""Muzzle Flash detection,"" and Panic Focus kills."


Asset #,Key Element,Generation Prompt
1,HUD & World,"First-person view of a snowy, post-apocalyptic 1960s New York City street. The HUD shows a minimalist white health bar, a 1960s compass, and a 45% radiation bar."
2,Car Crawl,"Third-person gameplay shot of a survivor prone, sliding under a rusted 1960s sedan in a snow-covered New York street. Arm-mounted Geiger counter glows orange."
3,Factions,"Concept art character line-up: NYPD officer (winter coat/flashlight), MP soldier (gas mask/rifle), and Scavenger (ragged fur/makeshift mask)."
4,Ankle Pull,Third-person gameplay angle from ground-level. Survivor hidden under a rusted 1960s Cadillac reaching out to grab the ankle of a passing NYPD officer.
5,Sanctuary,"Cinematic image of a ""Campfire Sanctuary"" inside a frozen transit bus. Survivor sitting by a fire drum, tinkering with their arm-scanner. HUD in ""Menu Mode."""
6,The Stalker,Boss Stalker encounter: A tall figure in a lead-lined diving-style suit glowing green. Survivor huddled behind a bus wheel. HUD shows Radiation spike (80%).
7,The Ending,"Survivor in a theater dressing room, holding arm-scanner over glowing blueprints for ""Project Nightfall"" near a ham radio. New objective: ""FIND THE SIGNAL TOWER."""
8,Combat Peak,"Survivor in a ""Corner Lean"" firing an M3 Grease Gun. Large muzzle flash, snowing environment, Panic Focus UI active."


This flowchart serves as the **Level Design & Narrative Pacing Guide** for the "Frozen Fallout" Vertical Slice. It outlines the player's journey from a vulnerable survivor to a desperate combatant, ensuring every mechanic we've designed is introduced at the right time.

---

### **15-Minute Gameplay Flowchart: The "Broadway Push"**

| Time | Segment | Primary Objective | Mechanics Introduced |
| --- | --- | --- | --- |
| **00:00 - 02:00** | **The Awakening** | Exit the Grand Central Terminal subway mouth into the blizzard. | **HUD & Movement:** Cold Meter, Compass, and Arm-Scanner initialization. |
| **02:00 - 04:00** | **First Contact** | Bypass a Scavenger picketing a food cache near a 1961 Chrysler. | **Stealth:** Tutorial for **"The Car Crawl."** Sneak under the car to grab "Pristine" Iodine. |
| **04:00 - 06:00** | **The Wind Tunnel** | Navigate the 42nd St. crosswind where "Black Snow" is falling. | **Hazard Management:** Using the Scanner to find safe "Squeeze Gaps" to avoid Rad Spikes. |
| **06:00 - 08:00** | **The Sanctuary** | Reach the Frozen Transit Bus lodged in a theater entrance. | **Progression:** The **Campfire.** Upgrade the Scanner and find the hidden **M3 Grease Gun.** |
| **08:00 - 11:00** | **The Escalation** | Move toward Times Square. Witness an MP squad executing Scavengers. | **Environmental Stealth:** Using high-ground (Bus Ledges) and the **"Ankle Pull"** on a straggling MP. |
| **11:00 - 13:00** | **The Trap** | A siren triggers. NYPD and MPs lock down the sector. You are pinned. | **Pressure:** Introduction of the **"Panic Focus"** UI as the survivor is surrounded. |
| **13:00 - 15:00** | **The Combat Peak** | Break through the blockade to reach the Signal Tower. | **Combat:** Using **Corner Leans** and **Muzzle Flashes** to take down 3+ enemies. |

---

### **Technical Breakdown for Developers**

#### **The "Transition" Logic (Stealth to Combat)**

The game must handle the transition from **Silent Scavenging** to **Violent Gunplay** through a "State Change" in the HUD:

1. **Stealth State:** Scanner pings are low-frequency. Music is minimal (wind and Geiger clicks).
2. **Combat State:** When the first shot is fired, the HUD "glitches" briefly. The **Panic Focus** meter fills. The music shifts to a rhythmic, heavy industrial thumping (mimicking a heartbeat).

#### **Animation States for Gunplay**

* **Idle to Ready:** Character unbuttons their heavy coat slightly to reach the M3 Grease Gun.
* **The "Recoil Struggle":** Because it’s a 1960s steel weapon, the character's shoulders should shake violently. The survivor should lean forward, fighting to keep the barrel down.
* **Corner Pivot:** If the player is in a **Corner Lean**, the animation must blend a "Look-out" with a "Weapon Raise."

---

### **Visualizing the "Transition" Moment**

I will generate a technical reference image showing the **Survivor in the middle of a "Corner Lean,"** transitioning from hiding to firing. This will showcase the **body positioning, the grip on the 1960s weapon, and the lighting effects of the muzzle flash in the snow.**

> **Image Prompt:** A high-detail technical animation reference. The survivor is pressed against the corner of a rusted, green 1962 station wagon. They are in a "Corner Lean" stance, body low, knees bent in deep snow. They are firing an M3 Grease Gun. A massive, smoky orange muzzle flash illuminates the character's fur-lined hood and the frozen car. The arm-scanner on their sleeve is glowing. In the background, two NYPD officers are caught in the flash, one falling back. The HUD is visible: Compass vibrating, Health bar at 50%, and the "Panic Focus" meter active in the center.
> The 15-minute flowchart serves as the technical "Beat Sheet" for your level designers and scripters. It ensures that the transition from a vulnerable, stealth-focused survivor to a desperate combatant feels earned and mechanical.

---

### **1. The 15-Minute Gameplay Flowchart: "The Broadway Push"**

| Time | Segment | Primary Objective | Mechanics Introduced |
| --- | --- | --- | --- |
| **00:00 - 02:00** | **The Awakening** | Exit the Grand Central Terminal subway mouth into the blizzard. | **Introduction:** Navigation HUD, Cold/Temperature meter, and first "Radiation Hotzone." |
| **02:00 - 05:00** | **First Contact** | Bypass a scavenger group picketing a food cache. | **Stealth:** Tutorial for **"The Car Crawl."** Slink under a '64 Impala to steal "Pristine" Iodine. |
| **05:00 - 08:00** | **The Sanctuary** | Reach the "Theater Bus" campsite. | **Progression:** The **Campfire** (Warmth/Decon). Loot the **M3 Grease Gun** from a dead Courier. |
| **08:00 - 11:00** | **The Squeeze** | Navigate a narrow gap between a jackknifed transit bus and a wall. | **Verticality:** Tutorial for **"Bus Ledges"** to bypass a heavy MP patrol on the ground. |
| **11:00 - 13:00** | **The Trigger** | An MP patrol spots you. The "Panic Focus" mechanic engages. | **Escalation:** Transition from Stealth to Combat. First use of the **"Corner Lean."** |
| **13:00 - 15:00** | **Combat Peak** | Survive a multi-enemy firefight to reach the Signal Tower. | **Combat:** High-recoil gunplay, **"Muzzle Flash detection,"** and **Panic Focus** kills. |

---

### **2. Technical Transition: Stealth to Combat**

To ensure the "Panic Focus" feels distinct, the game must undergo a **state-change** the moment the first shot is fired:

* **Audio Shift:** The ambient wind fades out. A rhythmic, muffled heartbeat (120 BPM) starts. Geiger clicks transition from "Warning" to a "Steady Alarm" tone.
* **Visual Filter:** The screen edges desaturate, focusing all color on the **Orange Glow** of the Arm-Scanner and enemy silhouettes.
* **AI State:** Patrols move from "Search" (Flashlights out) to "Suppress" (Firing toward the last known muzzle flash).

---

### **3. The Combat Peak Image (Visualizing the Corner Lean)**

This image is for your animators. It demonstrates the **Survivor's body positioning** during a "Corner Lean," the **mechanical recoil** of the M3 Grease Gun, and the **Panic Focus UI** highlighting multiple threats.

**Prompt Used:**

> *A high-detail technical animation reference. The survivor is pressed against the corner of a rusted, green 1962 station wagon in a snowy NYC street. They are in a "Corner Lean" stance, body low, knees bent, firing an M3 Grease Gun. A massive, smoky orange muzzle flash illuminates the character's fur-lined hood and the falling snow. The survivor's arm-scanner glows bright orange. In the mid-ground, two Military Police officers in gas masks are reacting to the gunfire. The HUD shows the "Panic Focus" meter active: the time is slightly slowed, and the central health bar is at 30% and fractured.*

http://googleusercontent.com/image_generation_content/2

---

### **4. Master Project List: Phase 1 Completed Images & Prompts**

This is the "Visual Bible" to copy into your master document.

| Asset # | Key Element | Generation Prompt |
| --- | --- | --- |
| **1** | **HUD & World** | First-person view of a snowy, post-apocalyptic 1960s New York City street. The HUD shows a minimalist white health bar, a 1960s compass, and a 45% radiation bar. |
| **2** | **Car Crawl** | Third-person gameplay shot of a survivor prone, sliding under a rusted 1960s sedan in a snow-covered New York street. Arm-mounted Geiger counter glows orange. |
| **3** | **Factions** | Concept art character line-up: NYPD officer (winter coat/flashlight), MP soldier (gas mask/rifle), and Scavenger (ragged fur/makeshift mask). |
| **4** | **Ankle Pull** | Third-person gameplay angle from ground-level. Survivor hidden under a rusted 1960s Cadillac reaching out to grab the ankle of a passing NYPD officer. |
| **5** | **Sanctuary** | Cinematic image of a "Campfire Sanctuary" inside a frozen transit bus. Survivor sitting by a fire drum, tinkering with their arm-scanner. HUD in "Menu Mode." |
| **6** | **The Stalker** | Boss Stalker encounter: A tall figure in a lead-lined diving-style suit glowing green. Survivor huddled behind a bus wheel. HUD shows Radiation spike (80%). |
| **7** | **The Ending** | Survivor in a theater dressing room, holding arm-scanner over glowing blueprints for "Project Nightfall" near a ham radio. New objective: "FIND THE SIGNAL TOWER." |
| **8** | **Combat Peak** | Survivor in a "Corner Lean" firing an M3 Grease Gun. Large muzzle flash, snowing environment, Panic Focus UI active. |

---

### **Phase 1: Mission Accomplished**

We have defined the **Atmosphere, UI, Stealth, Factions, Progression, Boss Logic, Narrative Hook, and Combat Mechanics.**

**What is the next objective for Phase 2?**

1. **Level Design Map:** Draft a top-down layout of the "Times Square Blockade" showing all crawlspaces and sniper perches?
2. **Inventory & Looting UI:** Design the screens for repairing "Pristine" items and managing ammo?
3. **Enemy AI Flowcharts:** Define exactly how an MP reacts when they find a "Car Crawl" tunnel?


This Phase 2 document provides the **Tactical Level Layout** for the "Times Square Blockade," the combat-heavy climax of our vertical slice. This map is designed for level designers and environment artists to build the 3D space with precise stealth-to-combat pathing.

---

### **1. Top-Down Tactical Map: The Times Square Blockade**

The "Bowtie" intersection of Broadway and 7th Avenue has been transformed into a frozen killbox. The map below uses a standard tactical legend to define player movement and enemy vantage points.

```text
LEGEND:
[ S ] - Start Point (South Entrance)      [###] - Heavy Blockade (Impassable)
[ E ] - Exit Point (Signal Tower)         [... ] - Squeeze Gap (Side-stepping)
[ = ] - Car Crawl Space (Under Vehicle)   [ B ] - Bus Ledge (Vertical Path)
[ ! ] - Sniper Perch (MP Vantage)         [ H ] - Hot Zone (Radiation Spike)
[ C ] - Cover (Low-Wall/Debris)           [ * ] - Campfire (Sanctuary)
[ G ] - Guard Patrol Path                 [ P ] - Panic Focus Trigger Zone

```

#### **The Layout (Mid-Town Manhattan, 45th to 47th St)**

```text
      ____________________[ E ]____________________
     |          (Signal Tower Entrance)            |
     |      [ H ]                  [ H ]           |
     |   [ ! ]              [ B ]             [ ! ]|  <-- 47th St Blockade
     |    / \                / \               / \ |
     |___| G |______________| G |_____________| G |_|
     |                      [ P ]                  |
     |        [ C ]         (Killzone)     [ C ]   |
     |   [ = ]         [ B ]         [ = ]         |  <-- Times Square Center
     |   (Taxi)       (Bus)         (Limo)         |
     |          [...]         [...]                |
     |   [ C ]         [ * ]         [ C ]         |  <-- The Sanctuary (Duffy Sq)
     |                (Camp)                       |
     |     [ G ]           [ G ]           [ G ]   |
     |______\______________/_______________\_______|
     |   [ = ]         [ = ]         [ = ]         |  <-- Entrance Row
     |   (Sedan)      (Truck)       (Sedan)        |
     |____________________[ S ]____________________|

```

---

### **2. Level Design Specs: Traversal & Hazards**

#### **2.1 The Crawlspace Network ([ = ])**

* **Asset:** Rusted 1960s yellow cabs and delivery trucks.
* **Function:** These form a "Sub-Floor" path. Players can traverse 40% of the map without being seen by ground patrols, but they are vulnerable to the **Stalker** boss who can hear movement on the car metal.
* **Dev Note:** Must include "Oil Puddles" under cars that slow movement and increase noise.

#### **2.2 The Squeeze Gaps ([ ... ])**

* **Asset:** Tight alleys formed by jackknifed 1960s transit buses and concrete debris.
* **Function:** Forces the player into a 2D side-stepping animation. Limits vision but provides total cover from Snipers.
* **Animation Req:** Survivor must flatten against the wall, head tilted to watch the exit.

#### **2.3 Sniper Perches ([ ! ])**

* **Asset:** Billboards and second-story theater balconies (e.g., The Palace Theatre).
* **Function:** MPs with spotlights. If the player stays in a light for >2 seconds, the **Blockade Lockdown** triggers, filling the **Panic Focus** meter instantly.

---

### **3. Animation Reference: Using the Environment**

To guide the animators, we have detailed how the survivor interacts with the specific geometry of this map.

| Position | Animation Action | Gameplay Benefit |
| --- | --- | --- |
| **Bus Ledge [ B ]** | **The Belly Slide:** Sliding flat on top of a bus to avoid searchlights. | Avoids ground-level gas traps. |
| **Car Crawl [ = ]** | **The Low-Profile Peek:** Lifting the head just above the tire rim to scan. | Grants 360-degree vision while 90% obscured. |
| **Corner Lean [ C ]** | **High/Low Swap:** Ability to fire from a standing lean or a kneeling lean. | Confuses AI suppression fire. |

---

### **Visualizing the Layout: The Top-Down Blueprint**

I will generate a professional top-down level design sketch. This will serve as the "Blue-Line" map for the environment team, showing the paths, the cover points, and the glowing "Hot Zones."

> **Image Prompt:** A professional top-down game level design blueprint of a post-apocalyptic Times Square. The map is hand-drawn style on aged vellum paper. It shows clear tactical symbols: blue lines for "Crawl Paths" under cars, red cones for "Enemy Sightlines," and orange circles for "Radiation Hotspots." The "Bowtie" intersection is filled with stalled 1960s vehicles. A legend on the side defines "Bus Ledge," "Squeeze Gap," and "Sniper Perch." Gritty, technical, and detailed for game developers.

http://googleusercontent.com/image_generation_content/3

---

### **Phase 2 Status Report**

1. **Level Map:** Drafted and Visualized.
2. **Pathing:** Defined (Stealth-Under, Vertical-Over, Tactical-Squeeze).
3. **Enemy Placement:** Sniper and Patrol zones established.

**Should we finish Phase 2 with:**

1. **The Inventory & Looting UI:** Showing how to scrap 1960s car parts for weapon repairs?
2. **The "Stalker" AI Behavior Tree:** A flowchart showing how the boss hunts the player through these specific crawlspaces?



Position,Animation Action,Gameplay Benefit
Bus Ledge [ B ],The Belly Slide: Sliding flat on top of a bus to avoid searchlights.,Avoids ground-level gas traps.
Car Crawl [ = ],The Low-Profile Peek: Lifting the head just above the tire rim to scan.,Grants 360-degree vision while 90% obscured.
Corner Lean [ C ],High/Low Swap: Ability to fire from a standing lean or a kneeling lean.,Confuses AI suppression fire.

# Game Design Document: Atomic Winter '60

## 1. High Concept

**Working Title:** *Atomic Winter '60: The Silent Crossing*
**Genre:** Third-person survival shooter / Stealth action
**Setting:** A post-apocalyptic, retro-futuristic 1960s New York City. Following a limited nuclear exchange and subsequent nuclear winter, the city is a frozen graveyard of mid-century Americana.
**Art Style:** Stylized/Cartoon (Game-like), leaning into a "thick-line" illustrative look while maintaining the grit of the setting.

---

## 2. Core Pillars

* **Stealth over Combat:** Ammunition is a luxury. Combat is a "fail state" or a desperate last resort. Navigation involves crawling under 1960s vehicles and shimmying through gaps.
* **Resource Management:** Every item must be scanned with a Geiger counter. Highly irradiated items are worthless or dangerous; "clean" items are high-value trade goods.
* **Retro-Aesthetic:** Everything—from the tail-finned cars to the political advertisements (Nixon vs. Kennedy era)—is frozen in 1960.
* **Tactical Survival:** No regenerating health. Players must find Med Stations or trade for "clean" medical supplies.

---

## 3. World & Environment

### Key Locations

* **Times Square:** The initial gauntlet. Ruined theaters, vintage billboards (Coca-Cola, Pan Am), and snow-clogged streets.
* **Midtown Manhattan (45th to 47th St):** A major hub containing makeshift survivor camps.
* **Survivor Camps:** Densely packed areas featuring:
* Improvised tents and shelters.
* Photo booths repurposed for identification or storage.
* Makeshift defenses using crashed 1960s vehicles.



### Environmental Hazards

* **Nuclear Winter:** (Optional/Seasonal) Heavy snow and freezing temperatures requiring appropriate gear.
* **Radiation Zones:** Craters and "hot" debris that drain life expectancy.
* **Factions:**
* **The Blue Coats:** Rogue remnants of the NYPD in tattered vintage uniforms.
* **The MPs:** Rogue Military Police, the most well-armed threat.
* **The Scavengers:** Desperate civilians using "home-grown" weapons like bows and bats.



---

## 4. Characters: The Scavenger (Player)

**Visual Identity:**

* **Style:** Cartoonish but detailed.
* **Gear:** Thick wool coat, layered improvised armor, heavy boots (kept "normal" in design), vintage military helmet, and a half-face respirator.
* **Essential Tool:** Handheld analog Geiger counter.
* **Abilities:** * Crouch-walking and prone crawling (under trucks/trailers).
* Stealth takedowns (headlocks/chokeholds).
* Climbing and shimmying between wreckage.



---

## 5. Gameplay Mechanics

### The Loot System (Top 10 Items)

1. **Civil Defense Medkit:** High value, restores health.
2. **Canned Peaches:** Primary food source.
3. **Iodine Tablets:** Reduces radiation exposure.
4. **Water Flask:** Essential for stamina.
5. **Hershey’s Bar:** Quick energy boost.
6. **Tire Iron:** Durable melee weapon and tool.
7. **Geiger Counter:** Essential for scanning loot.
8. **Scrap Metal:** Low-value trade junk (often irradiated).
9. **Empty Fire Extinguisher:** Distraction tool (can be thrown).
10. **Ammunition (.38 Special):** Extremely rare; used for the service revolver.

### Combat & Stealth

* **Enemies:** Usually encountered in small groups (3–5 max).
* **Stealth:** Using the environment (tunnels, car wrecks, tent cities) to bypass threats.
* **Animations:** Distinct "flinch" and "impact" reactions when the player is hit, emphasizing vulnerability.

---

## 6. Asset Guidelines

* **Vehicles:** Iconic 1960s models (Ford Galaxies, Chevy Impalas, Checker Cabs). Crashed versions should be stripped of spare tires and isolated from background for easier integration.
* **Buildings:** Iconic 60s architecture (Mid-century Modern) shown in various states:
1. *Pristine/Era-accurate:* For flashback or world-building.
2. *Post-Apocalyptic:* Ruined, weathered, and integrated into camps.


* **Camps:** Focus on "Single Tent" assets and "Improvised Shelter" modules to build out the 45th–47th St area.
* **Props:** Photo booths, 1960s political posters, and vintage vending machines.