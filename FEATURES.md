# Daily Planner - Features & Architecture Documentation

## App Architecture

### Design Pattern: MVVM (Model-View-ViewModel)

```
┌─────────────────────────────────────────────────────────┐
│                       UI Layer (Views)                  │
│  ┌──────────┬──────────┬──────────┬──────────┬────────┐ │
│  │Dashboard │ Habits   │  Todos   │  Usage   │ Settings
│  └──────────┴──────────┴──────────┴──────────┴────────┘ │
└─────────────────────────────────────────────────────────┘
                      ↕️ Binding
┌─────────────────────────────────────────────────────────┐
│               ViewModel Layer (Business Logic)          │
│  ┌─────────────────┬──────────────┬────────────────────┐│
│  │HabitViewModel   │TodoViewModel │DashboardViewModel ││
│  │- createHabit()  │- createTodo()│- calcScore()      ││
│  │- toggleComplete │- toggleDone()│- refreshData()    ││
│  │- fetchHabits()  │- filterTodos │- motivation()     ││
│  └─────────────────┴──────────────┴────────────────────┘│
└─────────────────────────────────────────────────────────┘
                      ↕️ Fetch/Save
┌─────────────────────────────────────────────────────────┐
│                  Services Layer                         │
│  ┌──────────────────┬────────────────┬────────────────┐ │
│  │CoreDataManager   │NotificationSvc │WeatherService  │ │
│  │- Save habits     │- Schedule      │- Fetch data    │ │
│  │- Save todos      │- Send alerts   │- News format   │ │
│  │- Query data      │- Cancel notif  │                │ │
│  └──────────────────┴────────────────┴────────────────┘ │
└─────────────────────────────────────────────────────────┘
                      ↕️ Persist
┌─────────────────────────────────────────────────────────┐
│              Core Data (Persistence)                    │
│  ┌──────────┬────────┬────────────┬──────────┬────────┐ │
│  │  Habits  │ Todos  │DailyScores │AppUsage  │Health  │ │
│  └──────────┴────────┴────────────┴──────────┴────────┘ │
└─────────────────────────────────────────────────────────┘
```

## Feature Breakdown

### 1. 🏆 Habit Tracking System

#### Good & Bad Habits
- **Good Habits**: Actions you want to do daily (exercise, meditation, reading)
- **Bad Habits**: Actions you want to avoid or reduce (smoking, excessive scrolling)
- Displayed in separate tabs for organization

#### Data Tracked per Habit
```swift
Habit {
  id: UUID                    // Unique identifier
  name: String               // "Exercise", "Read", "Meditate"
  category: String           // "Health", "Learning", "Fitness"
  isGoodHabit: Bool          // true/false
  createdDate: Date          // When habit was created
  currentStreak: Int         // Current consecutive days
  bestStreak: Int            // All-time best streak
  timesCompleted: Int        // Total completions
  isCompleted: Bool          // Today's status
  completedDate: Date?       // When completed today
  reminderTime: Date?        // Notification time
  hasReminder: Bool          // Reminder enabled
  parentHabit: Habit?        // Parent if child habit
  childHabits: [Habit]       // Sub-habits
  externalAppLink: String?   // Linked app (Journal)
  notes: String?             // Personal notes
}
```

#### Features
- ✅ Mark habits complete with one tap
- 🔥 Streak counter shows consecutive days
- 🎯 Category filtering
- ⏰ Optional reminder notifications
- 📊 Statistics tracking
- 🔗 External app integration

### 2. 👨‍👧‍👦 Child Habits (Multi-Level Tasks)

**Use Case**: "Take Vitamins" habit at different times
```
├─ Take Vitamins (Parent)
│  ├─ Vitamin D (8:00 AM)
│  ├─ Omega-3 (12:00 PM)
│  └─ Magnesium (9:00 PM)
```

**Implementation**:
- Each child habit has own reminder time
- Can complete child independently
- Parent completion only if all children done (optional)
- Display hierarchy in UI with indentation

### 3. ✅ Todo Management

#### Todo Types
- **One-Time Todos**: Complete once and remove
- **Recurring Todos**: Auto-create next day after completion
- **Categorized**: Work, Personal, Shopping, Health

#### Todo Properties
```swift
Todo {
  id: UUID
  title: String           // "Finish report"
  description: String?    // Additional details
  isCompleted: Bool       // Completion status
  dueDate: Date?          // When todo is due
  priority: String        // "high", "medium", "low"
  category: String        // Business classification
  isRecurring: Bool       // Daily repeat
  createdDate: Date
  completedDate: Date?
}
```

#### Filter Options
- 📋 All todos
- 📅 Today only
- ⚡ High priority only
- ✅ Completed ones
- ⏳ Pending ones

### 4. 📊 Daily Scoring System

#### Score Calculation Formula
```
Total Score = Habit Score + Todo Score + Usage Score

Habit Score:
  = (Completed Habits / Total Habits) × 40 points
  Max: 40 points

Todo Score:
  = (Completed Todos / Total Todos) × 40 points
  Max: 40 points

Usage Score:
  = max(0, 20 - (app_minutes / 30)) points
  Max: 20 points

Total: 0-100 points
```

#### Performance Levels
- 🌟 Excellent: 90-100 (Outstanding!)
- 💪 Great: 75-89 (Keep it up!)
- 👍 Good: 60-74 (On track!)
- 🎯 Fair: 45-59 (Focus on priorities!)
- 🚀 Needs Work: 0-44 (Let's turn it around!)

#### Motivation Messages
- Dynamic messages based on current score
- Encouragement at different levels
- Tips for improvement

### 5. 📱 Phone Usage Tracking

#### Manual Logging System
- Apps: Name, minutes spent
- Categories: Social Media, Games, Entertainment, Productivity, Other
- Daily aggregation
- Time-based insights

#### Usage Features
- 📊 Visual progress bar toward daily goal
- 🎯 Daily 8-hour (480 min) default goal
- 📉 Reduction score in daily assessment
- 💡 Recommendations for reducing usage
- 📈 Historical tracking and trends

#### Recommendations Shown
1. Set Screen Time Limits via iOS Settings
2. Use App Timers
3. Device-free hours
4. Replace scrolling with hobbies

### 6. 🔔 Notifications & Reminders

#### Types of Notifications
```
1. Habit Reminders
   └─ Time: User-specified (e.g., 7:00 AM)
   └─ Frequency: Daily
   └─ Content: "Don't forget: Exercise"

2. Todo Reminders
   └─ Time: Due date/time
   └─ Frequency: One-time
   └─ Content: "Todo Reminder: Finish report"

3. Daily Briefing
   └─ Time: 8:00 AM (customizable)
   └─ Frequency: Daily
   └─ Content: Summary of today's goals
```

#### Notification Features
- 🔕 Enable/disable from Settings
- ⏰ Custom notification times
- 🔊 Sound and badge support
- 📲 Can interact with notification
- 🚫 Cancel/manage pending notifications

### 7. 🌦️ Daily Dashboard

#### Components

**Daily Score Card**
- Large circular progress indicator
- Percentage score
- Performance level badge
- Motivation quote

**Motivation Section**
- Personalized message based on score
- Encouragement and tips
- Color-coded sentiment

**Progress Statistics**
- Habits completed (e.g., 3/5)
- Todos completed (e.g., 8/10)
- Phone usage (e.g., 120 minutes)
- Each with icon and color

**Daily Briefing**
- 🌤️ Weather: Mock data (can integrate real API)
- 📰 News: Customizable categories
- 📝 Catch-up summary

### 8. 🎨 UI/UX Design

#### Dark Mode Theme
- Base background: Deep dark gray/black
- Primary color: Blue gradient
- Accent colors: Purple, green, orange
- Text: White/gray hierarchy

#### Design Elements
- **Liquid Glass**: Semi-transparent cards with backdrop blur
- **Gradient Accents**: Blue-to-purple gradients for CTAs
- **Smooth Animations**: Transitions and state changes
- **Tab Navigation**: Bottom tabs for main sections
- **SF Symbols**: System icons throughout

#### Views
```
Tab Navigation
├─ Dashboard (home icon)
│  ├─ Daily score circle
│  ├─ Statistics cards
│  ├─ Motivation quote
│  └─ Weather + News
│
├─ Habits (checkmark icon)
│  ├─ Good habits tab
│  ├─ Bad habits tab
│  ├─ Habit cards with streaks
│  └─ Add new habit button
│
├─ Todos (list icon)
│  ├─ Filter options
│  ├─ Todo cards with priority
│  ├─ Completion checkboxes
│  └─ Add new todo button
│
├─ Usage (iPhone icon)
│  ├─ Usage gauge
│  ├─ Goal tracker
│  ├─ Recommendations
│  ├─ Usage logs
│  └─ Log new usage button
│
└─ Settings (gear icon)
   ├─ Notifications toggle
   ├─ Briefing time picker
   ├─ News categories
   ├─ Dark mode toggle
   ├─ About section
   └─ Data backup/export
```

### 9. ⚙️ Settings & Customization

#### Available Settings

**Account**
- Profile setup
- User preferences

**Notifications**
- Enable/disable notifications
- Custom briefing time
- Notification schedule

**Preferences**
- News category selection
- Display preferences
- Language (ready for localization)
- Reminder time slots

**Data**
- Backup data to cloud
- Export data as CSV/JSON
- Clear local data

**About**
- Version information
- Privacy policy link
- Terms of service link

### 10. 🔗 External App Integration

#### Integration Framework

**Journal App Integration**
```swift
journalHabit {
  externalAppLink: "com.apple.diary"
  appName: "Journal"
  whenComplete: () {
    // Could open Journal app
    // Or log integration event
  }
}
```

#### Possible Integrations
- 📔 Journal app for journaling habit
- 📱 Calendar for scheduling
- 🏃 Health app for fitness tracking
- 📊 Stocks for financial goals
- 📚 Books app for reading tracking

## Data Flow

### Creating a Habit
```
User taps "+" in Habits tab
    ↓
Sheet opens with form
    ↓
User fills: name, category, type, reminder
    ↓
Taps "Create Habit"
    ↓
HabitViewModel.createNewHabit()
    ↓
CoreDataManager creates NSHabit entity
    ↓
NotificationService schedules reminder
    ↓
UI refreshes, habit appears in list
```

### Completing a Habit
```
User taps habit circle
    ↓
HabitViewModel.toggleHabitCompletion()
    ↓
If not completed:
  - Set isCompleted = true
  - Increment streak
  - Update best streak if needed
  - Save to Core Data
    
If already completed:
  - Set isCompleted = false
  - Decrement streak
    ↓
CoreDataManager saves changes
    ↓
DashboardViewModel recalculates score
    ↓
UI updates automatically via @Published
```

### Daily Score Calculation
```
Every morning (or on app launch):
    ↓
CoreDataManager.calculateAndSaveDailyScore()
    ↓
Fetch today's habits and todos
    ↓
Count completed vs total for each
    ↓
Apply formula with weights
    ↓
Save NSDailyScore entity
    ↓
DashboardViewModel displays in score card
```

## State Management

### Published Properties

**HabitViewModel**
```swift
@Published var habits: [NSHabit]
@Published var newHabitName: String
@Published var isGoodHabit: Bool
@Published var reminderEnabled: Bool
```

**TodoViewModel**
```swift
@Published var todos: [NSTodo]
@Published var newTodoTitle: String
@Published var newTodoPriority: String
@Published var isRecurring: Bool
```

**DashboardViewModel**
```swift
@Published var dailyScore: Double
@Published var todayHabitsCompleted: Int
@Published var appUsageMinutes: Int
@Published var weatherData: String
@Published var newsItems: [String]
```

## Core Data Schema

### Entities Relationships
```
NSHabit
  ├─ hasMany: childHabits (Habit.parentHabit)
  └─ hasOne: parentHabit (Habit.childHabits)

NSTodo
  └─ no relationships (independent)

NSDailyScore
  └─ no relationships (independent)

NSAppUsageLog
  └─ no relationships (independent)

NSHealthEntry
  └─ no relationships (independent)
```

### Fetch Requests Used
1. All habits (excluding child habits)
2. All todos sorted by due date
3. Today's todos only
4. High-priority todos
5. Today's app usage logs
6. Today's daily score

## Performance Optimizations

### Memory Management
- ✅ Use `@FetchRequest` for large lists
- ✅ Lazy loading of list items
- ✅ Release large collections after use
- ✅ Clear unused Core Data objects

### Database Optimization
- ✅ Indexed fetch requests
- ✅ Predicate filtering (not in-memory)
- ✅ Sorted descriptors in query
- ✅ Batch operations for bulk saves

### UI Responsiveness
- ✅ Background threads for CoreData operations
- ✅ Debounce frequent updates
- ✅ Use `.onChange()` sparingly
- ✅ Memoize calculated properties

## Security Considerations

### Data Protection
- ✅ All data stored locally on device
- ✅ No cloud storage by default
- ✅ No user tracking
- ✅ No external API calls (mock data)

### Privacy
- ✅ No file system access required
- ✅ No network permissions needed
- ✅ No contact list access
- ✅ Optional: HealthKit access (disabled by default)

## Testing Scenarios

### Habit Testing
```
Test 1: Create good habit
- Create habit with name, category
- Verify appears in good habits list
- Verify streak is 0

Test 2: Complete habit daily
- Complete habit day 1 ✓ (streak = 1)
- Uncomplete, verify streak = 0
- Complete again ✓ (streak = 1)
- Day 2: Complete ✓ (streak = 2)

Test 3: Child habits
- Create parent habit
- Add 3 child habits with times
- Verify all appear in tree
- Complete each independently
```

### Todo Testing
```
Test 1: Create recurring todo
- Create with isRecurring = true
- Complete it ✓
- Verify new todo created for tomorrow
- Both appear in list

Test 2: Filter todos
- Create 5 todos with different dates/priorities
- Filter "Today" - only today shown
- Filter "High Priority" - only high shown
```

### Score Testing
```
Test 1: Score calculation
- 3 habits created, 2 completed = 40 × (2/3) = 26.67
- 2 todos, 1 completed = 40 × (1/2) = 20
- Usage = 75 min = 20 - (75/30) = 17.5
- Total = 26.67 + 20 + 17.5 = 64.17

Test 2: Motivation message
- Score 95 → "Excellent!"
- Score 68 → "Good progress!"
- Score 30 → "Let's turn it around!"
```

## Potential Enhancements

### Phase 2
- [ ] Real weather API (WeatherKit)
- [ ] Real news API (NewsAPI)
- [ ] Statistics/analytics page
- [ ] Habit suggestions engine
- [ ] Social sharing
- [ ] Achievement badges

### Phase 3
- [ ] CloudKit sync
- [ ] Multi-device support
- [ ] iCloud backup/restore
- [ ] Apple Watch app
- [ ] Home screen widget
- [ ] Siri shortcuts

### Phase 4
- [ ] AI-powered insights
- [ ] Machine learning for habit predictions
- [ ] Social challenges
- [ ] Leaderboards
- [ ] Habit recommendation engine
- [ ] Advanced analytics

## Conclusion

Daily Planner is a comprehensive habit and task tracking app built with modern iOS technologies. The clean MVVM architecture makes it maintainable and extensible. All data stays on-device ensuring privacy while still providing powerful tracking and motivation features through a beautiful, intuitive interface.
