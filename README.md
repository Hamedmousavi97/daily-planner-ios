# Daily Planner iOS App

A comprehensive iOS app for daily and weekly planning that helps improve habits and manage daily tasks. Built with SwiftUI, MVVM architecture, and Core Data persistence.

## Features

### 1. Habit Tracking
- Create and manage good and bad habits
- Track habits daily with streak motivation
- Categorize habits
- Mark habits as complete/incomplete
- View habit statistics and streaks

### 2. Child Habits
- Support for multi-level habits (e.g., vitamins at different times)
- Schedule child habits at specific times
- Organize complex routines

### 3. Todo Management
- Create job-related todos
- Support for daily recurring and one-time todos
- Mark todos as complete
- Organize todos by priority

### 4. Daily Scoring
- Automatic daily scoring based on completed habits and todos
- Daily brief with performance metrics
- Motivation tracking

### 5. Integrations
- Connect to Journal app for tracking journaling habits
- Integration framework for external apps
- App usage tracking and logging

### 6. Notifications & Reminders
- Local notifications for habit reminders
- Customizable notification times
- Snooze options

### 7. Daily Dashboard
- Weather and news briefing
- Customizable news categories in settings
- Daily catch-up summary

### 8. Phone Usage Tracking
- Log daily app usage
- Manual usage time entry
- Usage statistics and recommendations
- Performance marks based on usage reduction

### 9. UI/UX Design
- Dark mode support
- Liquid glass morphism design
- Smooth animations
- Intuitive navigation

## Tech Stack

- **Language**: Swift
- **UI Framework**: SwiftUI
- **Architecture**: MVVM
- **Data Persistence**: Core Data
- **Local Storage**: UserDefaults
- **Notifications**: UserNotifications Framework
- **Integrations**: EventKit, HealthKit (optional)

## Project Structure

```
DailyPlanner/
├── App/
│   ├── DailyPlannerApp.swift
│   └── AppDelegate.swift
├── Models/
│   ├── Habit.swift
│   ├── Todo.swift
│   ├── DailyScore.swift
│   └── AppIntegration.swift
├── ViewModels/
│   ├── HabitViewModel.swift
│   ├── TodoViewModel.swift
│   ├── DashboardViewModel.swift
│   └── SettingsViewModel.swift
├── Views/
│   ├── MainTabView.swift
│   ├── HabitsView/
│   ├── TodosView/
│   ├── DashboardView/
│   ├── SettingsView/
│   └── Components/
├── Services/
│   ├── CoreDataService.swift
│   ├── NotificationService.swift
│   ├── WeatherService.swift
│   ├── NewsService.swift
│   └── AppIntegrationService.swift
└── Resources/
    └── Assets.xcassets
```

## How to Run

### Requirements
- Xcode 15.0+
- iOS 16.0+
- macOS 13.0+

### Setup

1. Open the Xcode project:
   ```bash
   open DailyPlanner.xcodeproj
   ```

2. Select your target device or simulator

3. Press `Cmd + R` to build and run

### Using TestFlight

1. Archive the app:
   - Select in Xcode: Product > Archive
   - Sign with your development team

2. Upload to TestFlight:
   - Open App Store Connect
   - Go to TestFlight
   - Click on the app
   - Add build
   - Select the archived build
   - Add test information and submit for review

3. Share with testers:
   - Generate public link or add specific testers
   - Share the link with test participants

4. Testers install:
   - Testers click the link
   - Open in TestFlight app
   - Tap "Install"

## Development Notes

- All data is stored locally using Core Data
- Notifications are scheduled daily for habits
- UI updates are reactive using SwiftUI State management
- Dark mode is fully supported throughout the app

## Future Enhancements

- CloudKit sync for multi-device support
- Statistics and analytics dashboard
- Habit suggestions based on AI
- Social features for habit challenges
- Widget support for home screen
- Watch app companion

## License

MIT License - Copyright (c) 2026

## Support

For issues or feature requests, please contact the developer.
