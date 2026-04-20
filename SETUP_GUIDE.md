# Daily Planner iOS App - Setup Guide

## Project Overview

This is a complete iOS app for daily and weekly planning built with **SwiftUI** and **MVVM Architecture**. The app helps users track habits, manage todos, log phone usage, and improve productivity through daily scoring.

## Quick Setup (GitHub Clone)

### Step 1: Clone the Repository

```bash
git clone https://github.com/Hamedmousavi97/daily-planner-ios.git
cd daily-planner-ios
```

### Step 2: Open in Xcode

1. Open Xcode
2. File → Open → Select the `DailyPlanner.xcodeproj` file
3. The project will open with all files and configurations ready

### Step 3: Build and Run

1. Select a simulator or device
2. Press `Cmd + R` to build and run
3. Grant notification permissions when prompted

## Manual Setup (If Not Using GitHub)

If you prefer to create the project manually, follow these steps:

### Step 1: Create Xcode Project

1. Open Xcode
2. Create a new project: `File` → `New` → `Project`
3. Choose **iOS** → **App**
4. Name it: **DailyPlanner**
5. Team: Select your development team
6. Organization name: Your name/company
7. Bundle identifier: `com.yourname.dailyplanner`
8. Language: **Swift**
9. User Interface: **SwiftUI**
10. Click "Create"

### Step 2: Add Core Data Model

1. File → New → File → Data Model
2. Name it: `DailyPlanner`
3. Add the following entities with attributes:

### Step 3: Copy All Swift Files

Copy all the Swift files from the provided directory into your Xcode project:

**App Files:**

- DailyPlannerApp.swift

**Models:**

- Models/CoreDataModels.swift

**Services:**

- Services/CoreDataManager.swift
- Services/NotificationService.swift

**ViewModels:**

- ViewModels/HabitViewModel.swift
- ViewModels/TodoViewModel.swift
- ViewModels/DashboardViewModel.swift

**Views:**

- Views/MainTabView.swift
- Views/DashboardView.swift
- Views/HabitsView.swift
- Views/TodosView.swift
- Views/AppUsageView.swift
- Views/SettingsView.swift

### Step 4: Configure Info.plist

Add the following keys to your Info.plist:

```xml
<key>NSCalendarsUsageDescription</key>
<string>Daily Planner needs access to your calendar for event management</string>

<key>NSHealthShareUsageDescription</key>
<string>Daily Planner wants to read your health data</string>

<key>NSHealthUpdateUsageDescription</key>
<string>Daily Planner wants to write your health data</string>

<key>UIUserInterfaceStyle</key>
<string>Dark</string>
```

### Step 5: Enable Required Capabilities

In Xcode:

1. Select your **DailyPlanner** project in the left sidebar
2. Select the **Targets** → **DailyPlanner**
3. Go to the **Signing & Capabilities** tab

**Add these capabilities:**

#### Push Notifications (REQUIRED)

- Click **+ Capability** button (top left)
- Search for **"Push Notifications"** or **"Remote Notifications"**
- Click it to add
- ✅ Make sure the checkbox is **enabled**

**Note:** If you don't see "Push Notifications", try:

- It might be labeled "Remote Notifications"
- Or check under "Background Modes" → enable "Remote notifications"

#### Background Modes (Optional)

- Click **+ Capability**
- Search for **"Background Modes"**
- A list of checkboxes will appear
- ✅ Enable these:
  - ✓ Background fetch (optional, for periodic syncing)
  - ✓ Remote notifications (enables push notifications to work in background)

#### HealthKit (Optional)

- Click **+ Capability**
- Search for **"HealthKit"**
- ✅ Enable the checkbox if you want health data integration

**Summary:**

- **Push Notifications**: Required ✅ (must enable)
- **Background Modes**: Optional (enable for better notification handling)
- **HealthKit**: Optional (only if using health tracking)

### Step 6: Build and Run

1. Select a simulator or device
2. Press `Cmd + R` to build and run
3. Grant notification permissions when prompted

## Features Included

✅ **Habit Tracking** - Good and bad habits with streaks
✅ **Child Habits** - Sub-habits with individual scheduling
✅ **Todo Management** - Work todos with priorities and recurrence
✅ **Daily Scoring** - Automatic performance scoring
✅ **Phone Usage Tracking** - Log and monitor app usage
✅ **Notifications & Reminders** - Local notification system
✅ **Dark Mode** - Full dark mode support with liquid glass design
✅ **Settings** - News categories, notification times, display options
✅ **Dashboard** - Daily briefing with weather and news mock data

## Testing on Device

### Using TestFlight

1. Build & Archive:

   ```
   Product → Archive
   ```

2. Upload to TestFlight:
   - Xcode Organizer → Distribute App
   - Select App Store Connect
   - Select TestFlight
   - Choose automatic signing
   - Submit for review

3. Share with Testers:
   - Go to App Store Connect
   - Select your app → TestFlight
   - Invite testers via email
   - Testers install via TestFlight app

### Direct Device Testing

1. In Xcode: Select your device/simulator from the target selector
2. Press `Cmd + R` to build and run directly on the device

## Customization Tips

1. **Change App Icon**:
   - Assets.xcassets → AppIcon
   - Add your 1024x1024 icon

2. **Change App Colors**:
   - Modify the LinearGradient colors in views
   - Update accent colors in View definitions

3. **Add Real API Integration**:
   - Replace mock weather data in `DashboardViewModel`
   - Integrate real weather API (WeatherKit, OpenWeatherMap)
   - Integrate real news API (NewsAPI, etc.)

4. **Enable CloudKit Sync**:
   - Add CloudKit capability
   - Modify CoreDataManager to use NSPersistentCloudKitContainer

## Troubleshooting

**Issue: Core Data migration errors**

- Solution: Delete app from simulator and rebuild

**Issue: Notifications not working**

- Solution: Check Info.plist has NSCalendarsUsageDescription
- Make sure you granted permission when prompted

**Issue: Views not updating**

- Solution: Ensure @ObservedObject and @StateObject are used correctly
- Verify CoreData changes trigger `.onChange()` observers

## Next Steps

1. Add real weather API integration
2. Add news API integration
3. Implement journal app integration using App Intents
4. Add statistics and analytics page
5. Create widget for home screen
6. Add Apple Watch companion app
7. Enable CloudKit for multi-device sync

## Project Dependencies

This project uses only Apple frameworks:

- SwiftUI
- Core Data
- User Notifications
- EventKit (optional)
- HealthKit (optional)

No external dependencies required!
