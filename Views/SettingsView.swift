import SwiftUI

struct SettingsView: View {
    @State private var notificationsEnabled = true
    @State private var dailyBriefingTime = Date()
    @State private var selectedNewsCategories: [String] = ["Technology", "Health", "Productivity"]
    @State private var darkModeEnabled = true
    @AppStorage("appLanguage") private var appLanguage = "English"
    @AppStorage("appIcon") private var appIcon = "calendar"
    
    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color(red: 0.1, green: 0.1, blue: 0.12),
                        Color(red: 0.12, green: 0.12, blue: 0.15)
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 20) {
                        // Account Settings
                        VStack(spacing: 12) {
                            SectionHeader(title: "Account")
                            
                            NavigationLink(destination: Text("Coming Soon")) {
                                SettingRow(
                                    icon: "person.circle",
                                    label: "Profile",
                                    value: "Setup your profile"
                                )
                            }
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color.white.opacity(0.05))
                                .backdrop(.thin)
                        )
                        .padding()
                        
                        // Notifications
                        VStack(spacing: 12) {
                            SectionHeader(title: "Notifications")
                            
                            Toggle(isOn: $notificationsEnabled) {
                                HStack {
                                    Image(systemName: "bell.fill")
                                        .foregroundColor(.blue)
                                        .frame(width: 24)
                                    Text("Enable Notifications")
                                        .foregroundColor(.white)
                                }
                            }
                            .onChange(of: notificationsEnabled) { newValue in
                                if newValue {
                                    NotificationService.shared.requestNotificationPermission()
                                } else {
                                    NotificationService.shared.cancelAllNotifications()
                                }
                            }
                            .padding()
                            
                            if notificationsEnabled {
                                VStack(spacing: 12) {
                                    HStack {
                                        Text("Daily Briefing")
                                            .font(.caption)
                                            .foregroundColor(.gray)
                                        Spacer()
                                        DatePicker("", selection: $dailyBriefingTime, displayedComponents: .hourAndMinute)
                                            .labelsHidden()
                                    }
                                    .padding()
                                    .background(Color.white.opacity(0.05))
                                    .cornerRadius(12)
                                    
                                    Button(action: {
                                        NotificationService.shared.scheduleDailyBriefing()
                                    }) {
                                        HStack {
                                            Image(systemName: "checkmark.circle")
                                            Text("Enable Daily Briefing")
                                        }
                                        .font(.caption)
                                        .frame(maxWidth: .infinity)
                                        .padding()
                                        .background(Color.blue.opacity(0.2))
                                        .cornerRadius(8)
                                    }
                                    .foregroundColor(.blue)
                                }
                            }
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color.white.opacity(0.05))
                                .backdrop(.thin)
                        )
                        .padding()
                        
                        // News Categories
                        VStack(spacing: 12) {
                            SectionHeader(title: "News Categories")
                            
                            VStack(spacing: 8) {
                                ForEach(["Technology", "Health", "Productivity", "Wellness", "Science"], id: \.self) { category in
                                    Toggle(isOn: Binding(
                                        get: { selectedNewsCategories.contains(category) },
                                        set: { newValue in
                                            if newValue {
                                                selectedNewsCategories.append(category)
                                            } else {
                                                selectedNewsCategories.removeAll { $0 == category }
                                            }
                                        }
                                    )) {
                                        Text(category)
                                            .foregroundColor(.white)
                                    }
                                    .padding()
                                }
                            }
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color.white.opacity(0.05))
                                .backdrop(.thin)
                        )
                        .padding()
                        
                        // Display Settings
                        VStack(spacing: 12) {
                            SectionHeader(title: "Display")
                            
                            Toggle(isOn: $darkModeEnabled) {
                                HStack {
                                    Image(systemName: "moon.stars.fill")
                                        .foregroundColor(.yellow)
                                        .frame(width: 24)
                                    Text("Dark Mode")
                                        .foregroundColor(.white)
                                }
                            }
                            .padding()
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color.white.opacity(0.05))
                                .backdrop(.thin)
                        )
                        .padding()
                        
                        // About
                        VStack(spacing: 12) {
                            SectionHeader(title: "About")
                            
                            VStack(spacing: 8) {
                                SettingRow(icon: "info.circle", label: "App Version", value: "1.0.0")
                                SettingRow(icon: "doc.text", label: "Privacy Policy", value: "View")
                                SettingRow(icon: "square.and.pencil", label: "Terms of Service", value: "View")
                            }
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color.white.opacity(0.05))
                                .backdrop(.thin)
                        )
                        .padding()
                        
                        // Backup & Export
                        VStack(spacing: 12) {
                            SectionHeader(title: "Data")
                            
                            Button(action: { }) {
                                HStack {
                                    Image(systemName: "icloud.and.arrow.up")
                                        .foregroundColor(.blue)
                                    
                                    Text("Backup Data")
                                        .foregroundColor(.white)
                                    
                                    Spacer()
                                    
                                    Image(systemName: "chevron.right")
                                        .foregroundColor(.gray)
                                }
                                .padding()
                                .background(Color.white.opacity(0.05))
                                .cornerRadius(12)
                            }
                            
                            Button(action: { }) {
                                HStack {
                                    Image(systemName: "square.and.arrow.up")
                                        .foregroundColor(.green)
                                    
                                    Text("Export Data")
                                        .foregroundColor(.white)
                                    
                                    Spacer()
                                    
                                    Image(systemName: "chevron.right")
                                        .foregroundColor(.gray)
                                }
                                .padding()
                                .background(Color.white.opacity(0.05))
                                .cornerRadius(12)
                            }
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color.white.opacity(0.05))
                                .backdrop(.thin)
                        )
                        .padding()
                        
                        Spacer(minLength: 20)
                    }
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct SectionHeader: View {
    let title: String
    
    var body: some View {
        Text(title)
            .font(.headline)
            .foregroundColor(.white)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct SettingRow: View {
    let icon: String
    let label: String
    let value: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.blue)
                .frame(width: 24)
            
            Text(label)
                .foregroundColor(.white)
            
            Spacer()
            
            Text(value)
                .font(.caption)
                .foregroundColor(.gray)
            
            Image(systemName: "chevron.right")
                .foregroundColor(.gray)
                .font(.caption)
        }
        .padding()
        .background(Color.white.opacity(0.05))
        .cornerRadius(12)
    }
}

extension View {
    func backdrop(_ thickness: Material.Thickness) -> some View {
        self.background(Material.ultraThin)
    }
}

#Preview {
    SettingsView()
}
