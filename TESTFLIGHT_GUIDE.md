# TestFlight Distribution Guide

## What is TestFlight?

TestFlight is Apple's beta testing platform that allows you to distribute your iOS app to testers before submitting to the App Store. It's the official way to test apps with real devices.

## Step-by-Step TestFlight Setup

### Prerequisites

Before using TestFlight, ensure you have:
- Apple Developer Account ($99/year)
- Xcode installed on your Mac
- DailyPlanner app fully built and ready
- Apple ID for signing

### Step 1: Prepare Your App for Archive

1. Open your project in Xcode
2. Connect your device or select a simulator
3. Go to **Product** → **Clean Build Folder** (`Cmd + Shift + K`)
4. Build the app: **Product** → **Build** (`Cmd + B`)

### Step 2: Create an Archive

1. Go to **Product** → **Archive**
   - Make sure you've selected a device target (not simulator)
   
2. Wait for the build to complete

3. The Organizer window will open automatically

4. Your archive should appear in the list

### Step 3: Validate and Upload to TestFlight

1. In the Organizer, select your archive
2. Click **Validate App**
   - Sign in with your Apple ID
   - Select your team
   - Check the validation options
   - Click **Validate**

3. Once validation passes, click **Distribute App**
   - Choose **App Store Connect**
   - Select **TestFlight only** (or without TestFlight if submitting)
   - Choose **Automatically manage signing** (recommended)
   - Select your team and bundle ID
   - Click **Next**

4. Review the summary and click **Upload**

5. Wait for the upload to complete (this may take a few minutes)

### Step 4: Configure on App Store Connect

1. Go to [App Store Connect](https://appstoreconnect.apple.com)

2. Sign in with your Apple ID

3. Select your app (DailyPlanner)

4. Go to **TestFlight** tab

5. Under **iOS Builds**, you should see your build

6. Click on the build number to configure:
   - **Test Information**:
     - What to test
     - Test notes
     - Sign-in information (if needed)
   
7. Fill in the test information:
   ```
   App Name: Daily Planner
   Build Version: 1.0
   What to Test: 
   - Habit tracking and streaks
   - Todo management
   - Daily scoring system
   - Phone usage tracking
   - Notification reminders
   - Settings customization
   
   Notes: 
   - Grant notification permissions when prompted
   - App uses Core Data for local storage
   - Requires iOS 16.0 or later
   ```

### Step 5: Invite Testers

#### Option A: Internal Testers (Apple Team Members)

1. Go to TestFlight → Testers tab
2. Add team members' Apple IDs
3. They'll receive an email invitation
4. They download TestFlight app and install your build

#### Option B: External Testers (Friends/Beta Users)

1. Go to TestFlight → Testers tab
2. Click the **+** to add external testers
3. Enter their email addresses (up to 10,000 testers)
4. Add to group or create new group
5. Click **Create**
6. Apple reviews the beta (usually 24-48 hours)
7. Once approved, testers receive invitation emails

#### Option C: Public Link (Anyone can Test)

1. Go to TestFlight → App Information
2. Click **Public Link**
3. Select your build
4. Check **Enable Public Link for this Build**
5. Copy the link
6. Share link via:
   - Email
   - Social media
   - Website
   - QR code (can generate from link)
7. Anyone with the link can install via TestFlight

### Step 6: Tester Installation

**For Testers:**

1. Download **TestFlight** app from App Store
2. Open invitation email or click public link
3. Click **Accept Invitation** or **Start Testing**
4. Tap **Install** button
5. App will download and install
6. Open app from TestFlight or home screen

### Step 7: Monitor Test Activity

1. In App Store Connect, go to **TestFlight** → **Feedback**
2. View:
   - Crash logs
   - Performance metrics
   - Tester feedback
   - Sessions per device

3. Go to **Testers** to see:
   - How many times app was installed
   - Last session date
   - Device information

### Step 8: Deploy Updates

When you make changes:

1. Update version/build number in Xcode:
   - Select Project → General
   - Change "Build" number (e.g., 1.0.1)

2. Repeat steps 1-3 (Archive and Upload)

3. New build automatically becomes available to testers

4. Testers get notification about new version

## TestFlight Best Practices

### Build Number Strategy
```
Version (Major.Minor.Patch)
Build (increments)

Example:
1.0.0 (first release candidate)
1.0.1 (bug fix)
1.1.0 (new features)
2.0.0 (major rewrite)
```

### Release Notes Template
```
Build 1.0.1 - Bug Fixes & Improvements

What's New:
• Fixed notification scheduling bug
• Improved dark mode rendering
• Enhanced daily score calculation
• Better habit streak tracking

Known Issues:
• Weather data is mocked (API integration pending)

Testing Focus:
• Test habit creation and completion
• Verify notifications work at scheduled times
• Check todo list filtering options
• Test dark mode across all screens
```

### Feedback Collection
- Use TestFlight feedback feature
- Create Google Form for detailed surveys
- Request specific bug reports
- Ask for performance feedback

## Common TestFlight Issues & Fixes

### Issue: Build Rejected During Review

**Cause**: App uses restricted API or violates guideline

**Fix**:
- Review App Store Review Guidelines
- Remove any private API usage
- Check for missing privacy descriptions
- Update Info.plist with required keys

**Sample Info.plist for Daily Planner:**
```xml
<key>NSCalendarsUsageDescription</key>
<string>Daily Planner needs access to calendar for event scheduling</string>

<key>NSNotificationCenterUsageDescription</key>
<string>Daily Planner needs notification permissions for reminders</string>

<key>UIUserInterfaceStyle</key>
<string>Dark</string>

<key>NSAppTransportSecurity</key>
<dict>
  <key>NSAllowsArbitraryLoads</key>
  <false/>
</dict>
```

### Issue: Testers Can't Install

**Causes & Fixes**:
1. iOS version too old → Update iOS on test device
2. Device not added to account → Add in Identifiers & Profiles
3. Provisioning profile expired → Renew in Xcode
4. TestFlight app outdated → Update from App Store

### Issue: Crashes During Testing

**Debugging**:
1. Check TestFlight crash logs in App Store Connect
2. Reproduce on Xcode with device
3. Use Debug navigator to find crash location
4. Push fix and create new build

### Issue: Memory/Performance Problems

**Monitoring**:
1. Xcode Organizer shows device metrics
2. Check memory usage during habit loading
3. Profile with Instruments if needed
4. Optimize Core Data queries

## TestFlight Limitations

- ⏱️ Builds expire after 90 days
- 🔄 Testers auto-remove if not used after 30 days
- 📊 Limited to 10,000 external testers per app
- 🌐 Regional limitations may apply

## After TestFlight - App Store Submission

When ready to publish:

1. Complete App Store listing:
   - Screenshots
   - Description
   - Keywords
   - Category
   - Support URL

2. Submit for Review:
   - Go to App Store Connect
   - Select build for submission
   - Fill in version release notes
   - Select pricing tier
   - Click Submit for Review

3. Apple reviews (typically 24-48 hours)

4. Once approved, schedule release:
   - Automatic (released immediately)
   - Manual (you choose release date)
   - Phased (rolled out gradually)

## TestFlight for DailyPlanner Specific Tips

### Pre-Release Checklist
```
□ All features working (habits, todos, scoring)
□ Notifications scheduling correctly  
□ Dark mode rendering properly
□ Data persists after app close
□ No console errors or warnings
□ Performance acceptable on iPhone 12 and newer
□ Tested on iOS 16 and iOS 17
□ Settings save correctly
□ App icon appears in home screen
```

### Testing Scenarios
1. **First Launch Experience**
   - Create first habit
   - Set notification reminder
   - Create first todo

2. **Daily Workflow**
   - Mark habits complete
   - Receive notifications
   - Check daily score
   - Log app usage

3. **Edge Cases**
   - Add 20+ habits and todos
   - Complete/uncomplete multiple times
   - Test app after 24+ hours (streak calculation)
   - Test with app in background

## Support & Resources

- [TestFlight Help](https://help.apple.com/testflight/)
- [App Store Connect Help](https://help.apple.com/app-store-connect/)
- [App Store Review Guidelines](https://developer.apple.com/app-store/review/guidelines/)
- [Xcode Help](https://help.apple.com/xcode/)

## Summary

TestFlight workflow for Daily Planner:
```
1. Archive app in Xcode
2. Validate and upload to App Store Connect
3. Add test information and notes
4. Invite testers (internal/external/public)
5. Testers download via TestFlight app
6. Monitor feedback and crash logs
7. Fix issues and push new builds
8. Repeat until ready for App Store
9. Submit final build for App Store review
```

Happy Testing! 🎉
