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
*Make sure to copy the `export_presets.cfg` below before opening Godot.
<details>
  <summary>Export Presets</summary>

  ```
[preset.0]

name="iOS Development"
platform="iOS"
runnable=true
dedicated_server=false
custom_features=""
export_filter="all_resources"
include_filter=""
exclude_filter=""
export_path="../exports/ios/scaling-broccoli.ipa"
encryption_include_filters=""
encryption_exclude_filters=""
encrypt_pck=false
encrypt_directory=false
script_encryption_key=""

[preset.0.options]

custom_template/debug=""
custom_template/release=""
architectures/arm64=true
application/app_store_team_id="376E7RMFX3"
application/provisioning_profile_uuid_debug=""
application/code_sign_identity_debug=""
application/export_method_debug=1
application/provisioning_profile_uuid_release=""
application/code_sign_identity_release=""
application/export_method_release=0
application/targeted_device_family=2
application/bundle_identifier="com.kida.matchymatchysamesame"
application/signature=""
application/short_version="1.0"
application/version="1.0"
application/icon_interpolation=4
application/launch_screens_interpolation=4
capabilities/access_wifi=true
capabilities/push_notifications=false
user_data/accessible_from_files_app=false
user_data/accessible_from_itunes_sharing=false
privacy/camera_usage_description=""
privacy/camera_usage_description_localized={}
privacy/microphone_usage_description=""
privacy/microphone_usage_description_localized={}
privacy/photolibrary_usage_description=""
privacy/photolibrary_usage_description_localized={}
icons/iphone_120x120="res://../arts/game-icon/GameIcon-120.png"
icons/iphone_180x180=""
icons/ipad_76x76="res://../arts/game-icon/GameIcon-76.png"
icons/ipad_152x152="res://../arts/game-icon/GameIcon-152.png"
icons/ipad_167x167=""
icons/app_store_1024x1024="res://../arts/game-icon/GameIcon-1024.png"
icons/spotlight_40x40=""
icons/spotlight_80x80=""
icons/settings_58x58=""
icons/settings_87x87=""
icons/notification_40x40=""
icons/notification_60x60=""
storyboard/use_launch_screen_storyboard=false
storyboard/image_scale_mode=0
storyboard/custom_image@2x=""
storyboard/custom_image@3x=""
storyboard/use_custom_bg_color=false
storyboard/custom_bg_color=Color(0, 0, 0, 1)
landscape_launch_screens/iphone_2436x1125=""
landscape_launch_screens/iphone_2208x1242=""
landscape_launch_screens/ipad_1024x768=""
landscape_launch_screens/ipad_2048x1536=""
portrait_launch_screens/iphone_640x960=""
portrait_launch_screens/iphone_640x1136=""
portrait_launch_screens/iphone_750x1334=""
portrait_launch_screens/iphone_1125x2436=""
portrait_launch_screens/ipad_768x1024=""
portrait_launch_screens/ipad_1536x2048=""
portrait_launch_screens/iphone_1242x2208=""

[preset.1]

name="iOS Production"
platform="iOS"
runnable=false
dedicated_server=false
custom_features=""
export_filter="all_resources"
include_filter=""
exclude_filter=""
export_path="../exports/ios/scaling-broccoli.ipa"
encryption_include_filters=""
encryption_exclude_filters=""
encrypt_pck=false
encrypt_directory=false
script_encryption_key=""

[preset.1.options]

custom_template/debug=""
custom_template/release=""
architectures/arm64=true
application/app_store_team_id="376E7RMFX3"
application/provisioning_profile_uuid_debug=""
application/code_sign_identity_debug="Apple Development"
application/export_method_debug=0
application/provisioning_profile_uuid_release=""
application/code_sign_identity_release="Apple Development"
application/export_method_release=0
application/targeted_device_family=2
application/bundle_identifier="com.kida.matchymatchysamesame"
application/signature=""
application/short_version="1.2"
application/version="1.2"
application/icon_interpolation=4
application/launch_screens_interpolation=4
capabilities/access_wifi=true
capabilities/push_notifications=false
user_data/accessible_from_files_app=false
user_data/accessible_from_itunes_sharing=false
privacy/camera_usage_description=""
privacy/camera_usage_description_localized={}
privacy/microphone_usage_description=""
privacy/microphone_usage_description_localized={}
privacy/photolibrary_usage_description=""
privacy/photolibrary_usage_description_localized={}
icons/iphone_120x120="res://../arts/game-icon/GameIcon-120.png"
icons/iphone_180x180=""
icons/ipad_76x76="res://../arts/game-icon/GameIcon-76.png"
icons/ipad_152x152="res://../arts/game-icon/GameIcon-152.png"
icons/ipad_167x167=""
icons/app_store_1024x1024="res://../arts/game-icon/GameIcon-1024.png"
icons/spotlight_40x40=""
icons/spotlight_80x80=""
icons/settings_58x58=""
icons/settings_87x87=""
icons/notification_40x40=""
icons/notification_60x60=""
storyboard/use_launch_screen_storyboard=false
storyboard/image_scale_mode=0
storyboard/custom_image@2x=""
storyboard/custom_image@3x=""
storyboard/use_custom_bg_color=false
storyboard/custom_bg_color=Color(0, 0, 0, 1)
landscape_launch_screens/iphone_2436x1125=""
landscape_launch_screens/iphone_2208x1242=""
landscape_launch_screens/ipad_1024x768=""
landscape_launch_screens/ipad_2048x1536=""
portrait_launch_screens/iphone_640x960=""
portrait_launch_screens/iphone_640x1136=""
portrait_launch_screens/iphone_750x1334=""
portrait_launch_screens/iphone_1125x2436=""
portrait_launch_screens/ipad_768x1024=""
portrait_launch_screens/ipad_1536x2048=""
portrait_launch_screens/iphone_1242x2208=""

[preset.2]

name="Android"
platform="Android"
runnable=true
dedicated_server=false
custom_features=""
export_filter="all_resources"
include_filter=""
exclude_filter=""
export_path="../exports/android/scaling-broccoli.aab"
encryption_include_filters=""
encryption_exclude_filters=""
encrypt_pck=false
encrypt_directory=false
script_encryption_key=""

[preset.2.options]

custom_template/debug=""
custom_template/release=""
gradle_build/use_gradle_build=true
gradle_build/export_format=1
gradle_build/min_sdk=""
gradle_build/target_sdk=""
architectures/armeabi-v7a=true
architectures/arm64-v8a=true
architectures/x86=false
architectures/x86_64=false
keystore/debug=""
keystore/debug_user=""
keystore/debug_password=""
keystore/release="RELEASE PATH"
keystore/release_user="RELEASE ALIAS"
keystore/release_password="RELEASE PASSWORD"
version/code=1
version/name="1.2"
package/unique_name="org.godotengine.gamejammerge"
package/name="Rainbow Rush"
package/signed=true
package/app_category=2
package/retain_data_on_uninstall=false
package/exclude_from_recents=false
launcher_icons/main_192x192="res://../arts/game-icon/GameIcon-192.png"
launcher_icons/adaptive_foreground_432x432="res://../arts/game-icon/GameIconForeground-432.png"
launcher_icons/adaptive_background_432x432="res://../arts/game-icon/GameIconBackground-432.png"
graphics/opengl_debug=false
xr_features/xr_mode=0
xr_features/hand_tracking=0
xr_features/hand_tracking_frequency=0
xr_features/passthrough=0
screen/immersive_mode=true
screen/support_small=true
screen/support_normal=true
screen/support_large=true
screen/support_xlarge=true
user_data_backup/allow=false
command_line/extra_args=""
apk_expansion/enable=false
apk_expansion/SALT=""
apk_expansion/public_key=""
permissions/custom_permissions=PackedStringArray()
permissions/access_checkin_properties=false
permissions/access_coarse_location=false
permissions/access_fine_location=false
permissions/access_location_extra_commands=false
permissions/access_mock_location=false
permissions/access_network_state=false
permissions/access_surface_flinger=false
permissions/access_wifi_state=false
permissions/account_manager=false
permissions/add_voicemail=false
permissions/authenticate_accounts=false
permissions/battery_stats=false
permissions/bind_accessibility_service=false
permissions/bind_appwidget=false
permissions/bind_device_admin=false
permissions/bind_input_method=false
permissions/bind_nfc_service=false
permissions/bind_notification_listener_service=false
permissions/bind_print_service=false
permissions/bind_remoteviews=false
permissions/bind_text_service=false
permissions/bind_vpn_service=false
permissions/bind_wallpaper=false
permissions/bluetooth=false
permissions/bluetooth_admin=false
permissions/bluetooth_privileged=false
permissions/brick=false
permissions/broadcast_package_removed=false
permissions/broadcast_sms=false
permissions/broadcast_sticky=false
permissions/broadcast_wap_push=false
permissions/call_phone=false
permissions/call_privileged=false
permissions/camera=false
permissions/capture_audio_output=false
permissions/capture_secure_video_output=false
permissions/capture_video_output=false
permissions/change_component_enabled_state=false
permissions/change_configuration=false
permissions/change_network_state=false
permissions/change_wifi_multicast_state=false
permissions/change_wifi_state=false
permissions/clear_app_cache=false
permissions/clear_app_user_data=false
permissions/control_location_updates=false
permissions/delete_cache_files=false
permissions/delete_packages=false
permissions/device_power=false
permissions/diagnostic=false
permissions/disable_keyguard=false
permissions/dump=false
permissions/expand_status_bar=false
permissions/factory_test=false
permissions/flashlight=false
permissions/force_back=false
permissions/get_accounts=false
permissions/get_package_size=false
permissions/get_tasks=false
permissions/get_top_activity_info=false
permissions/global_search=false
permissions/hardware_test=false
permissions/inject_events=false
permissions/install_location_provider=false
permissions/install_packages=false
permissions/install_shortcut=false
permissions/internal_system_window=false
permissions/internet=true
permissions/kill_background_processes=false
permissions/location_hardware=false
permissions/manage_accounts=false
permissions/manage_app_tokens=false
permissions/manage_documents=false
permissions/manage_external_storage=false
permissions/master_clear=false
permissions/media_content_control=false
permissions/modify_audio_settings=false
permissions/modify_phone_state=false
permissions/mount_format_filesystems=false
permissions/mount_unmount_filesystems=false
permissions/nfc=false
permissions/persistent_activity=false
permissions/process_outgoing_calls=false
permissions/read_calendar=false
permissions/read_call_log=false
permissions/read_contacts=false
permissions/read_external_storage=false
permissions/read_frame_buffer=false
permissions/read_history_bookmarks=false
permissions/read_input_state=false
permissions/read_logs=false
permissions/read_phone_state=false
permissions/read_profile=false
permissions/read_sms=false
permissions/read_social_stream=false
permissions/read_sync_settings=false
permissions/read_sync_stats=false
permissions/read_user_dictionary=false
permissions/reboot=false
permissions/receive_boot_completed=false
permissions/receive_mms=false
permissions/receive_sms=false
permissions/receive_wap_push=false
permissions/record_audio=false
permissions/reorder_tasks=false
permissions/restart_packages=false
permissions/send_respond_via_message=false
permissions/send_sms=false
permissions/set_activity_watcher=false
permissions/set_alarm=false
permissions/set_always_finish=false
permissions/set_animation_scale=false
permissions/set_debug_app=false
permissions/set_orientation=false
permissions/set_pointer_speed=false
permissions/set_preferred_applications=false
permissions/set_process_limit=false
permissions/set_time=false
permissions/set_time_zone=false
permissions/set_wallpaper=false
permissions/set_wallpaper_hints=false
permissions/signal_persistent_processes=false
permissions/status_bar=false
permissions/subscribed_feeds_read=false
permissions/subscribed_feeds_write=false
permissions/system_alert_window=false
permissions/transmit_ir=false
permissions/uninstall_shortcut=false
permissions/update_device_stats=false
permissions/use_credentials=false
permissions/use_sip=false
permissions/vibrate=false
permissions/wake_lock=false
permissions/write_apn_settings=false
permissions/write_calendar=false
permissions/write_call_log=false
permissions/write_contacts=false
permissions/write_external_storage=false
permissions/write_gservices=false
permissions/write_history_bookmarks=false
permissions/write_profile=false
permissions/write_secure_settings=false
permissions/write_settings=false
permissions/write_sms=false
permissions/write_social_stream=false
permissions/write_sync_settings=false
permissions/write_user_dictionary=false
  ```
</details>

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
  4. Make sure to increment the version since the last upload (**you version needs to be higher than the one in the Google Play Store**) (*SimVer*)
  5. Click `Export Project...`, and export it without `Debug`
3. Go to your project page in **Google Play Console**
  1. Select `Internal Testing`
  2. Drag and drop your `aab` file

### What icons will you need?

- [`192x192`](./arts/game-icon/GameIcon-192.png)
- [`432x432`](./arts/game-icon/GameIconForeground-432.png): foreground image, you will only use the inner `264px` circle
- [`432x432`](./arts/game-icon/GameIconBackground-432.png): background image

### What if I lost your upload key?
If you manage your key with Google Signing, they get you covered. Follow their [Create an upload key and update keystores](https://support.google.com/googleplay/android-developer/answer/9842756) guide.