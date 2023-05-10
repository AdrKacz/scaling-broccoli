# 🌈 Rainbow Rush

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
Each time you hit, you earn ten points times your current combo strike.

### Variables
- `score_factor`: the number of times you multiple your combo strike (*ten above*)

# What is a combo?
Combos are essential in arcade games as they incentivise you to continue the perfect strike and improve your skills.

## Option 1: You don't miss between two hits
After your second hit without a miss, you will start a combo. Then, you'll continue the combo until you don't miss it.
You miss if:
  - you tap when the square and the background don't have the same colour,
  - you don't tape when the square and the background have the same colour.
You will always have the chance to hit within the next five changement of colors. Five being the number of colors.

# How do I lose?
You lose when you miss.
You miss if you tap when the square and the background differ from the same colour.

# How do I play longer?
You can't play longer.

# How does the difficulty increase?
When you reach a given combo, you will increase your level.
The higher your level, the more likely you are to have match new to each other.
You reach level `1` at combo `10` and level `2` and combo `20`. You can't go higher than level `2`.

### Variables
- `background_delta`: the time the background keeps its colour when it doesn't match the colour of the square
- `background_match_delta`: the time the background keeps its colour when it matches the colour of the square
- `max_swaps`: array of maximum number of background color swaps before if match the color of the character at level `n`

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
