TODO:
- Add flash and screen shake and slow-mo (maybe slow-mo not needed)
- Remove zoom in shader if not used
- Replace the logic to write "Level X" inside the Level object so I can change the display text in one place only
# 🌈 Rainbow Rush
# Develop
Open `project.godot` with [**Godot**](https://godotengine.org/download/).

To see your changes, just click play in the top left corner.

See [tween cheat sheet](https://raw.githubusercontent.com/godotengine/godot-docs/master/img/tween_cheatsheet.webp).

## Resources for shaders
- [The book of shaders](https://thebookofshaders.com)
- [Godot shader snippets](https://godotshaders.com/snippet/useful-code-snippets/)

## Play on mobile
To be written...

# How to export?
*Make sure to copy the `export_presets.cfg` in `mobile-game` below before opening Godot.*
  
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

### What icons will you need?
- [`76x76`](./arts/game-icon/GameIcon-76.png)
- [`120x120`](./arts/game-icon/GameIcon-120.png)
- [`152x152`](./arts/game-icon/GameIcon-152.png)
- [`1024x1024`](./arts/game-icon/GameIcon-1024.png)

### What dimensions do you need for screenshots?
| Device  | Dimensions | Folder | *Debug Window Dimensions* | *Capture Dimensions* |
| ------------- | ------------- | ------------- | ------------- | ------------- |
| 6.7" Display  | `1290 x 2796` | `screen-67` | `665 x 1418` | `323 x 699` |
| 6.5" Display | `1284 x 2778` | `screen-65` | `662 x 1409` | `321 x 695` |
| 5.5" Display  | `1242 x 2208`  | `screen-55` | `641 x 1124` | `311 x 552` |
| 12.9" Display  | `2048 x 2732`  | `screen-129` | `1044 x 1386` | `512 x 683` |

### What dimensions do you need for app previews *(recordings)*?
| Device  | Dimensions | Folder | *Debug Window Dimensions* | *Capture Dimensions* |
| ------------- | ------------- | ------------- | ------------- | ------------- |
| 6.7" Display and 6.5" Display | `886 x 1920` | `preview-67-65` | `906 x 1940` | `443 x 960` |
| 5.5" Display  | `1080 x 1920`  | `preview-55` | `1130 x 1970` | `540 x 960` |
| 12.9" Display  | `1200 x 1600`  | `preview-129` | `1250 x 1650` | `600 x 800` |

### How to deploy to the Apple Store?
1. Go the App Store Connect and select your game
2. Get latest TestFlight version number
  1. Go to `TestFlight` tab
  2. Note the latest version number
3. Go to `App Store` tab
4. Click on the blue `+` sign next to `iOS App` on the upper-left
5. Enter the latest version number and hit `Create`
6. Edit the field according to [`./STORE_PRESENCE.md`](./STORE_PRESENCE.md)
  1. *You'll have to wait one hour before your app preview are done processing, you can close the browser meanwhile*
  2. Type the `Release Notes` in `What's new in This Version`
7. Select `Add build` and select your latest build
8. Hit `Save` ang go to `App information` under `General`
9. Edit the field according to [`./STORE_PRESENCE.md`](./STORE_PRESENCE.md)

## Android
1. Follow [Godot documentation *Exporting for Android*](https://docs.godotengine.org/en/stable/tutorials/export/exporting_for_android.html)
2. Open the project in your Godot editor
  1. Go to `Project > Install Android Build Template...` and select `Install`
  1. Select `Project > Export...`
  2. Select `Android` in **Presets**
  3. Fill in `Release`, `Release User`, and `Release Password`
  4. Increment the code version
  4. Make sure to increment the version since the last upload (**you version needs to be higher than the one in the Google Play Store**) (*SimVer*)
  5. Click `Export Project...`, and export it without `Debug`
3. Go to your project page in **Google Play Console**
  1. Select `Internal Testing`
  2. Upload your `aab` file
  3. Enter the release details and click **Next**
  4. If you add advertisement, see the notice below, you need to add something to your manifest and declare it
  5. Hit **Save and publish**

### What icons will you need?
- [`192x192`](./arts/game-icon/GameIcon-192.png)
- [`432x432`](./arts/game-icon/GameIconForeground-432.png): foreground image, you will only use the inner `264px` circle
- [`432x432`](./arts/game-icon/GameIconBackground-432.png): background image

### What if I lost your upload key?
If you manage your key with Google Signing, they get you covered. Follow their [Create an upload key and update keystores](https://support.google.com/googleplay/android-developer/answer/9842756) guide.

### Note on advertising$
Apps that use advertising ID and target Android 13 or later must declare the com.google.android.gms.permission.AD_ID permission in their app manifest. If you don't include this permission, your advertising identifier will be zeroed out, any attempts to access the identifier will receive a string of zeros instead of the identifier. [Learn more](https://support.google.com/googleplay/android-developer/answer/6048248?hl=en)

If you say that your app uses advertising ID, we will block releases that don't include the com.google.android.gms.permission.AD_ID permission in the manifest file when targeting Android 13. When we block these releases, we will remind you to add the permission. If your release doesn't need advertising ID, you'll be able to skip the error and release. You can also update the declaration to turn off advertising ID release errors.

The option selected is **No**.

### What dimensions do you need for app previews?
| Device  | Dimensions | *Debug Dimensions* | *Debug Factors*
| ------------- | ------------- | ------------- | ------------- |
| Any  | `1242x2208`  | `414x736` | `3` |
| App icon  | `512x512`  | *N/A* | *N/A* |
| Feature graphic  | `1024x500`  | *N/A* | *N/A* |

### How to deploy to the Google Play Store?
1. Go to the Google Play Console and select your app
2. Edit your app details
  1. Select `Main store listing` under `Store presence` on the left
  2. Edit the field according to [`./STORE_PRESENCE.md`](./STORE_PRESENCE.md)
  3. Hit `Save` and **don't send the change to review**
3. Create a new release
  1. Select `Production` under `Release` on the left
  2. Click `Create new release`
  3. Click `Add from library` and select the latest app bundle
  4. Enter the `release notes` from [`./STORE_PRESENCE.md`](./STORE_PRESENCE.md)
  5. Hit `Save`
  6. Review the release and click on `Save`
  7. Select `Go to oveview` in the pop-up window
  8. Click on `Send X changes for review` and confirm

## How to generetate app previews?
1. Install dependencies
  1. Install [**Loopback**](https://rogueamoeba.com/loopback/)
  2. Follow underboading step *(this will require to restart your computer)*
  3. Open **Loopback** and click the `New Virtual Device` *(it should create a `Loopback Audio` device)*
  4. Go to your computer `Settings > Audio` and select `Loopback Audio`
  5. Turn the sound at maximum *(it will start emitting sounds in your virtual device, you won't hear anything)*
1. Open your project in Godot
2. Go to `Project > Settings` and select `Window`
3. Update the `Debug dimensions`
4. Add at least `20px` in each dimensions to not see window frame while recording
5. Start the game and do the screenshots and screen recordings you need
6. Trim each video to `20s`
7. Scale up images and videos to their correct dimensions: `ffmpeg -i input -vf scale="iw*2:ih*2" output` *(scales times two)*
  1. If you need to scale small pixel art assets use: `ffmpeg -i input -vf scale="iw*2:ih*2" -sws_flags neighbor output`
  2. You can specify directly the dimensions to avoid artefacts: `ffmpeg -i input -vf scale="1200:1600" output`
8. Convert videos to `mp4`: `ffmpeg -i input.mov -qscale 0 output.mp4`
9. Extract frames from the videos: `ffmpeg -ss 01:23:45 -i input -frames:v 1 -q:v 2 output.png`

### What scenes do you want to preview?
1. Set the dimensions for screenshots
  1. Take a screenshot of the main menu
  2. Start recording your screen with correct dimensions *(audio doesn't matter)*
  3. Play a game with at least a combo higher than 25 and take screenshots of the lost menu
  4. Stop recording and extract in-game frame from your recording
    1. Take one frame with a combo higher than 20
    2. Take one random frame in game
    3. Take one frame with the introduction text
    4. Take another random frame in game
2. Set the dimensions for app preview
  1. Change your audio output to `LoopBack Audio`
  2. Change your recording audio channel to `LoopBack Audio`
  3. Turn on the `Music` and set volume at maximum
  4. Record your screen with correct dimensions
  5. Start a game, wait at the beginning to see the introduction message
  6. Do at least a combo higher than 50
  7. Stop recording your screen when you lose.
2. Record the game while you're in a combo higher than 25
3. Take a screenshot of the lose menu
4. Record the start of the game *(wait for the introduction message to appear)*
5. Take four screenshots from the two recording above

### Note for Apple Store
You will need to use `iMovie` to create the app preview. They won't upload if you don't export them with iMovie.
If you use `iMovie`, no need to rescale your `.mov` recording, `iMovie` will set the correct dimensions automatically.
For `12.9" Display` you'll need to rescale the video to `1200 x 1600` before importing it in `iMovie`. If you don't, `iMovie` will rescale it to `900 x 1200`.

### Note for Google Play Stores
You won't be able to upload videos directly. You must create a Youtube video and use the link.
> Add a video by entering a YouTube URL. This video must be public or unlisted, ads must be turned off, it must not be age restricted, and it should be landscape. 

# Need to attribute

> Paste these link on the website where your app is available for download or in the description section of the platform or marketplace you’re using.

 - <a href="https://www.flaticon.com/free-icons/thunder" title="thunder icons">Thunder icons created by Smashicons - Flaticon</a>

# The game
Rainbow Rush is a mobile arcade-like video game where you have to touch a square when its colour matches the colour of the background.
The square will keep its colour until you touch it when it has the same colour as the background.
The background keeps changing colour, and you must be fast and reactive!

You can take two directions to decide the rules.
  - Time is the main element
  - Hit is the main element
In the rules below, the main element is **hit** (*when you tap the square when its colour matches the colour of the background*). *Hit* is the dynamics. You **hit** when you play, so it keeps the central position for all the rules.

## How do I earn points?
Points are a common language between players to compare their performance and challenge each other. Points in arcade games be the best translation of the player's level possible.

### ~~Option 1: The longer you survive, the more points you'll have~~
### Option 2: You get points when you hit the correct colour
Each time you hit, you earn ten points times your current combo strike.

#### Variables
- `score_factor`: the number of times you multiple your combo strike (*ten above*)

## What is a combo?
Combos are essential in arcade games as they incentivise you to continue the perfect strike and improve your skills.

### Option 1: You don't miss between two hits
After your second hit without a miss, you will start a combo. Then, you'll continue the combo until you don't miss it.
You miss if:
  - you tap when the square and the background don't have the same colour,
  - you don't tape when the square and the background have the same colour.
You will always have the chance to hit within the next five changement of colors. Five being the number of colors.

## How do I lose?
You lose when you miss.
You miss if you tap when the square and the background differ from the same colour.

## How do I play longer?
You can't play longer.

## How does the difficulty increase?
When you reach a given combo, you will increase your level.
The higher your level, the more likely you are to have match new to each other.
You reach level `1` at combo `10` and level `2` and combo `20`. You can't go higher than level `2`.

#### Variables
- `background_delta`: the time the background keeps its colour when it doesn't match the colour of the square
- `background_match_delta`: the time the background keeps its colour when it matches the colour of the square
- `max_swaps`: array of maximum number of background color swaps before if match the color of the character at level `n`