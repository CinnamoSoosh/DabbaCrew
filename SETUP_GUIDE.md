# SIMPLE SETUP GUIDE - Dabba Crew Home Cook App

## Step 1: Open Terminal in VS Code
Press `Ctrl + ~` (tilde key below Esc)

## Step 2: Navigate to Downloads
```bash
cd C:\Users\Sushrut\Downloads
```

## Step 3: Create Flutter Project
```bash
flutter create dabba_crew_home_cook_app
```
Wait for it to finish (1-2 minutes)

## Step 4: Copy Files

### Create the pages folder:
1. Go to `dabba_crew_home_cook_app\lib\`
2. Create a new folder called `pages`

### Copy these files from the `files` folder:

**To `dabba_crew_home_cook_app\lib\`:**
- Copy `main.dart` (replace existing)

**To `dabba_crew_home_cook_app\lib\pages\`:**
- Copy `active_orders_page.dart`
- Copy `dashboard_page.dart`
- Copy `kitchen_verification_page.dart`
- Copy `menu_management_page.dart`
- Copy `profile_page.dart`
- Copy `registration_page.dart`

**To `dabba_crew_home_cook_app\`:**
- Copy `pubspec.yaml` (replace existing)

## Step 5: Open Project in VS Code
File → Open Folder → Select `dabba_crew_home_cook_app`

## Step 6: Get Dependencies
In terminal:
```bash
flutter pub get
```

## Step 7: Run the App
```bash
flutter run -d chrome
```

Done! 🎉

## Quick Commands Reference

- **Stop app**: Press `q` in terminal
- **Hot reload**: Press `r` in terminal (while app is running)
- **Restart app**: Press `R` in terminal
- **Clear terminal**: Type `cls` (Windows) or `clear` (Mac/Linux)

## Troubleshooting

**If you see errors:**
1. Make sure all files are in the correct folders
2. Run `flutter clean` then `flutter pub get`
3. Make sure Flutter is installed: `flutter --version`

**If Chrome doesn't work:**
```bash
flutter run
```
This will show available devices and you can select one
