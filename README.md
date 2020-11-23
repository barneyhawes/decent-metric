# decent-metric
Metric skin for Decent Espresso

Standing on the shoulders of giants: thanks to John (Insight), Damian (DSV), Sheldon (SWDark)

TODO - general
- Skin colours (dark / light theme)
- Add and test support for Bluetooth scale
- Test functionality of GHC somehow
- bug: Head temperature reading in status bar reads 100+ when DE1 is starting

TODO - pre-espresso page
- Change page title depending on home menu option selected
- Bean details should allow for longer text
- Bean details are not saved when edited
- Option to choose your grinder to set the range of values for grid size (and also save which grinder to the results file)
- Allow name and icon for Espresso and Filter to be specified

TODO - shot
- Save additional data to shot history

TODO - post-shot page
- Button to show chart full screen
- Option to compare with historic shot?

TODO - shot history
- Access to post-shot page for most recent shot at any time
- Display history list as a table showing the key stats (profile, dose, yield, time, temp, etc)
- Could offer sorting and filtering?
- Could offer "tick to compare" - allow up to 2 selections
 - Shot history to be filtered by shot type (espresso / filter)

Release notes
 - Support multiple settings files to allow multiple drinks to be configured
 - Implemented filter button on Home menu
 - Implemented selecting a profile
 - Implemented grind size setting
 - Implemented temperature setting
 - Added text for details of the beans being used

v0.5
 - New espresso menu screen with parameters for dose, grind, temp, ratio and yield
 - Reduced status bar to only show in corners
 - Head temperature meter reads the correct temperature
 - Water empty warning displayed at slightly higher level (sometimes did not display yet DE1 refused to start due to low water)
 - Water and temperature meters now read zero when DE1 disconnected
 - Automatically jump back to previous menu after steam or flush functions
 - Added labels to action buttons

v0.4 
- Added a timer to the Espresso page
- Added post-shot page to show summary of shot, chart and buttons for steam and flush
- Swapped water and temp meters on status bar so that they are closer to corresponding meters in Espresso window
- When the water level runs out, it will stay on the most recent page
- Detects when DE1 is not connected, displays a warning message and disables the start buttons
- Removed the "menu" page

v0.3 15/01/2020
- Added message to status bar during heating
- Added message to status bar when tank is empty, and removed "tankempty" page so you can stay in the menus
- Disabled espresso, steam, water and flush buttons when machine status is not ready
- Gauges no longer show target if value is zero.
- Weight gauge now shows scale weight if a scale connected, or falls back to volume of water dispensed.

v0.2 10/01/2020
- Separated main menu buttons for easier targetting
- Increased size of action buttons and re-laid out settings menu
- Return to main menu when exiting sleep
- Display target Espresso temperature, pressure and flow using settings from DE1.
- Added simple smoothing algorithm to meters (average of 2 values)

v0.1 06/01/2020
- first Alpha released to Decent Diaspora
