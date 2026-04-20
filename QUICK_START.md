# Daily Planner - Quick Start Guide

## ⚡ 5-Minute Setup

### What You Need
- Mac with Xcode 15+ installed
- Apple Developer Account (optional for simulator testing)
- iOS 16+ simulator or device

### Quick Steps

**Step 1: Clone the Repository** (30 seconds)
```bash
git clone https://github.com/Hamedmousavi97/daily-planner-ios.git
cd daily-planner-ios
```

**Step 2: Open in Xcode** (1 minute)
```bash
# The project is ready to open
1. Open Xcode
2. File → Open → Select DailyPlanner.xcodeproj
3. Click Open
```

**Step 3: Build and Run** (1 minute)
```bash
# In Xcode:
1. Select iPhone simulator (iOS 16+)
2. Press Cmd + R to build and run
3. Grant notification permissions when prompted
```

**Step 4: Start Using the App** (3 minutes)
```
The app includes:
✅ Habit tracking with streaks
✅ Todo management with priorities
✅ Daily scoring system
✅ Phone usage monitoring
✅ Dark mode with liquid glass design
✅ Local notifications
```

## Alternative: Manual Setup

If you prefer manual setup or don't want to use GitHub:

**Step 1: Create Xcode Project** (1 minute)
```bash
1. Open Xcode
2. File → New → Project → App
3. Name: DailyPlanner, Language: Swift, Interface: SwiftUI
4. Click Create
```

**Step 2: Copy Files** (2 minutes)
```bash
# Copy all files from this directory to your Xcode project:
- DailyPlannerApp.swift
- Models/CoreDataModels.swift
- Services/CoreDataManager.swift
- Services/NotificationService.swift
- ViewModels/*.swift
- Views/*.swift
- Assets.xcassets
- DailyPlanner.xcdatamodeld
```

**Step 5: Run** (30 seconds)
```
1. Select iPhone simulator from Xcode
2. Press Cmd + R or Product → Run
3. Grant notification permission when prompted
```

## 🚀 First Time Using the App

### Initial Setup
1. **Create Your First Habit**
   - Tap Habits tab
   - Tap + button
   - Enter: "Morning Exercise"
   - Category: "Fitness"
   - Enable Reminder: 7:00 AM
   - Type: Good Habit
   - Create

2. **Add a Todo**
   - Tap Todos tab
   - Tap + button
   - Enter: "Finish presentation"
   - Priority: High
   - Category: Work
   - Due Date: Today
   - Create

3. **Check Dashboard**
   - Tap Dashboard tab
   - See your daily score
   - View progress statistics
   - Read motivational message

4. **Log Phone Usage**
   - Tap Usage tab
   - Tap existing log (or create new)
   - Log: Instagram - 30 minutes
   - Watch score impact

5. **Customize Settings**
   - Tap Settings tab
   - Enable Daily Briefing: 8:00 AM
   - Select news categories
   - Configure preferences

## 📱 Testing Different Features

### Testing Habit Tracking
```
1. Create 3 habits: "Read", "Meditate", "Stretch"
2. Mark 2 as complete (✓)
3. Watch streaks increment
4. Check dashboard - scores update
5. Unmark one - see streak decrement
6. Next day: Check if carry-over works
```

### Testing Todo Management
```
1. Create a recurring todo: "Daily standup"
2. Mark it complete ✓
3. Create new todo appears for tomorrow
4. Filter by "Today" - shows current day
5. Filter by "High Priority" - shows only high
6. Try marking complete again
```

### Testing Daily Score
```
Scenario: Calculate your score
- 4 habits exist, you complete 3 = 30 points
- 2 todos exist, you complete 1 = 20 points
- Phone usage: 120 minutes = 16 points
- Total Score: 30 + 20 + 16 = 66 points ✓
```

### Testing Notifications
```
1. Go to Settings
2. Enable "Enable Daily Briefing"
3. Wait for briefing time (or test manually)
4. Check if notification appears
5. Tap notification - app opens
```

## 🐛 Troubleshooting

### App Won't Run
**Error: "Cannot find code..."**
- Solution: Make sure all .swift files copied to project
- Try: Product → Clean Build Folder (Cmd+Shift+K)
- Then: Product → Run (Cmd+R)

**Error: Core Data crash**
- Solution: Delete app from simulator
- Simulator → Device → Erase All Content
- Run again

### Features Not Working

**Notifications not appearing**
- Check: Go to Settings → Notifications
- Grant permission when auto-prompted
- Verify notification time is set

**Data not saving**
- Check console for Core Data errors
- Try: Product → Clean Build Folder
- Delete app and reinstall

**Dark mode not working**
- Verify: Info.plist has UIUserInterfaceStyle = Dark
- Force quit simulator or device
- Run app again

## 📊 App Structure

```
Daily Planner/
├── Files Provided:
│   ├── DailyPlannerApp.swift          ← Main app entry
│   ├── Models/
│   │   └── CoreDataModels.swift       ← Data entities
│   ├── Services/
│   │   ├── CoreDataManager.swift      ← Database operations
│   │   └── NotificationService.swift  ← Reminders
│   ├── ViewModels/
│   │   ├── HabitViewModel.swift       ← Habits logic
│   │   ├── TodoViewModel.swift        ← Todos logic
│   │   └── DashboardViewModel.swift   ← Dashboard logic
│   └── Views/
│       ├── MainTabView.swift          ← Tab navigation
│       ├── DashboardView.swift        ← Home screen
│       ├── HabitsView.swift           ← Habit tracking
│       ├── TodosView.swift            ← Todo management
│       ├── AppUsageView.swift         ← Phone usage
│       └── SettingsView.swift         ← Settings
│
├── Documentation:
│   ├── README.md                      ← Project overview
│   ├── SETUP_GUIDE.md                 ← Detailed setup
│   ├── TESTFLIGHT_GUIDE.md            ← Beta testing
│   ├── FEATURES.md                    ← Full feature docs
│   └── QUICK_START.md                 ← This file
```

## 🎯 Key Features to Try

- ✅ **Create & Mark Habits**: Build your routine
- ✅ **Child Habits**: Add vitamins at different times
- ✅ **Todo Recurring**: Auto-create daily tasks
- ✅ **Daily Score**: See how you're doing
- ✅ **Phone Tracking**: Log and reduce usage
- ✅ **Reminders**: Get notifications at set times
- ✅ **Dark Mode**: Beautiful dark interface
- ✅ **Badges**: Small visual feedback system

## 🔧 Customization Ideas

### Change Colors
In views, modify gradient colors:
```swift
// In MainTabView.swift
LinearGradient(
    gradient: Gradient(colors: [
        Color(red: 0.1, green: 0.1, blue: 0.12),      // ← Change these
        Color(red: 0.12, green: 0.12, blue: 0.15)
    ]),
    startPoint: .topLeading,
    endPoint: .bottomTrailing
)
```

### Add Real Weather
In DashboardViewModel.swift:
```swift
func fetchWeatherData() {
    // Replace mock data with real API call
    // Use: https://open-meteo.com (free)
    // weatherData = "Sunny, 72°F"
}
```

### Add Real News API
In DashboardViewModel.swift:
```swift
func fetchNewsData() {
    // Replace mock data with real API
    // Use: NewsAPI.org (free tier available)
    // newsItems = [...real articles...]
}
```

## 📲 Move to Physical Device

### Requirements
- iPhone 14+ running iOS 16+
- Apple Developer Account
- Connected to Xcode

### Steps
1. Connect iPhone via USB
2. Xcode will auto-detect device
3. Select device from target selector
4. Press Cmd+R to install
5. Trust developer on iPhone
6. App appears in home screen

## 🧪 Testing on Simulator

### Common Simulator Devices to Test
```
iPhone 15 Pro         ← Recommended
iPhone 15 Pro Max     ← Large screen
iPhone 14 Pro         ← Older device
iPhone SE (3rd gen)   ← Smallest screen
```

### Change Simulator
```
Xcode → Product → Destination → [Select Device]
```

## 💾 Backup & Export

### Save Your Data
In Settings → Data:
```
1. Tap "Backup Data"
2. Select iCloud or local
3. Tap "Backup"
```

### Export Data
```
1. Tap "Export Data"
2. Choose format (CSV/JSON)
3. Share via email/cloud
```

## 🚢 Ready for TestFlight?

When you're ready to test with others:
1. See: **TESTFLIGHT_GUIDE.md**
2. Archive your app (Product → Archive)
3. Upload to App Store Connect
4. Invite testers
5. Get feedback

---

## Quick Reference

| Feature | Tab | Shortcut |
|---------|-----|----------|
| Daily Score | Dashboard | ⌘1 |
| Habits | Habits | ⌘2 |
| Todos | Todos | ⌘3 |
| Phone Usage | Usage | ⌘4 |
| Settings | Settings | ⌘5 |

## Need Help?

- **App crashes**: Check console (View → Debug Area → Show Console)
- **Data missing**: Check Core Data stack in CoreDataManager
- **Features not working**: Verify notification permissions
- **Styling issues**: Check SwiftUI view modifiers
- **Performance slow**: Profile with Instruments

---

**Congratulations!** 🎉

You now have a fully functional habit tracking app. Start creating habits today and watch your score improve!

For detailed documentation, see **FEATURES.md** and **SETUP_GUIDE.md**.
