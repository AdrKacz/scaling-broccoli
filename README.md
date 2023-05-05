# Rainbow Rush

Rainbow Rush is a mobile arcade-like video game where you have to touch a square when its colour matches the colour of the background.
The square will keep its colour until you touch it when it has the same colour as the background.
The background keeps changing colour, and you must be fast and reactive!

You can take two directions to decide the rules.
  - Time is the main element
  - Hit is the main element
In the rules below, the main element is **hit** (*when you tap the square when its colour matches the colour of the background*). *Hit* is the dynamics. You **hit** when you play, so it keeps the central position for all the rules.

# How do I earn points?
Points are a common language between players to compare their performance and challenge each other. Points in arcade games be the best translation of the player's level possible.

## ~~Option 1: The longer you survive, the more points you'll have~~
## Option 2: You get points when you hit the correct colour
Each time you hit, you earn ten points times the number of lives you still have times your current combo strike.

### Variables
- `score_factor`: the number of times you multiply your number of lives (*ten above*)

# What is a combo?
Combos are essential in arcade games as they incentivise you to continue the perfect strike and improve your skills.

## Option 1: You don't miss between two hits
After your second hit without a miss, you will start a combo. Then, you'll continue the combo until you don't miss it.
You miss if:
  - you tap when the square and the background don't have the same colour,
  - you don't tape when the square and the background have the same colour.
You will always have the chance to hit within the next five changement of colors. Five being the number of colors.

## ~~Option 2: You don't miss within a time window ~~

# How do I lose?
## ~~Option 1: I don't have time left~~
## Option 2: I missed too many times
You start with three lives. Each time you miss, you lose a life. You lose once you lose your last life.
You miss if you tap when the square and the background differ from the same colour.

### Variables
- `max_lives`: maximum number of lives (*three above*)
- `start_lives`: number of lives at start (*three above*)

## ~~Option 3: A game always has the same duration~~

# ~~How do I lose time?~~
## ~~Option 1: You can't lose time~~
## ~~Option 2: You lose time when you miss~~

# How do I play longer?
## ~~Option 1: You can't play longer~~
## Option 2: You play longer when you hit in a combo
When you hit during a combo, you earn lives. You can never have more than three lives.
You will earn one life every ten hit in a row

### Variables
- `combos_reward_strike`: number of hit in a row to earn one life (*ten above*)

# How does the difficulty increase?
## ~~Option 1: The difficulty remains the same~~
## ~~Option 2: The difficulty increases ~~
## Option 3: The difficulty increases during a combo
Each time you hit during the combo, the background will change colour faster.
The background will keep its colour longer when it has the same as the colour of the square.

> The difficulty ramp will be defined later, as trials and errors are best to find the balance between too easy and too hard.

### Variables
- `background_delta`: the time the background keeps its colour when it doesn't match the colour of the square
- `background_match_delta`: the time the background keeps its colour when it matches the colour of the square

# How to export?
## iOS
1. Open the project in your Godot editor
  1. Select `Project > Export...`
  2. Select `iOS Production` in **Presets**
  3. Make sure to increment the version since the last upload (**you version needs to be higher than the one in the App Store, not in Test Flight**)
    1. Use `1.2.1 -> 1.2.2` (SimVer)
  3. Click `Export Project...`, and export it without `Debug`
  4. The archive build will fail with `error: "scaling-broccoli" requires a provisioning profile. Select a provisioning profile in the Signing & Capabilities editor.`, but the Xcode project will be created you can move forward
2. Open the Xcode project (`scaling-broccoli.xcodeproj`)
  1. Go to `Signing & Capabilities`
  2. Check `Automatically manage signing`
  3. Select your team
  4. Click on `Product > Archive`, it will build and open the **Archives** window
  5. Select your latest archive and click on `Distribute App`, a pop-up menu will open
  6. Select `App Store Connect`
  7. Select `Upload`
  8. Check `Upload your app's symbols` and `Manage Version and Build Number`
  9. Select `Automatically manage signing`
  10. Click on `Upload`, this will take a while
### How to renew your developer certificate?
You will need your developer certificate to export your app to the App Store.