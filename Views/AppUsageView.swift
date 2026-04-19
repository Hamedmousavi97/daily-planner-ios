import SwiftUI

struct AppUsageView: View {
    @State private var dailyMinutes: Int = 0
    @State private var showLogSheet = false
    @State private var usageLogs: [NSAppUsageLog] = []
    
    private let dataManager = CoreDataManager.shared
    
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
                        // Usage Summary
                        VStack(spacing: 16) {
                            HStack {
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Today's Usage")
                                        .font(.headline)
                                        .foregroundColor(.white)
                                    
                                    Text("Screen time")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                }
                                
                                Spacer()
                                
                                VStack(alignment: .trailing, spacing: 4) {
                                    Text("\(dailyMinutes)")
                                        .font(.title2)
                                        .fontWeight(.bold)
                                        .foregroundColor(.white)
                                    
                                    Text("minutes")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                }
                            }
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(Color.white.opacity(0.05))
                                    .backdrop(.thin)
                            )
                            
                            // Usage Goal
                            VStack(spacing: 8) {
                                HStack {
                                    Text("Daily Goal")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                    Spacer()
                                    Text("480 min")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                }
                                
                                GeometryReader { geometry in
                                    ZStack(alignment: .leading) {
                                        RoundedRectangle(cornerRadius: 8)
                                            .fill(Color.white.opacity(0.1))
                                        
                                        RoundedRectangle(cornerRadius: 8)
                                            .fill(
                                                LinearGradient(
                                                    gradient: Gradient(colors: [.orange, .red]),
                                                    startPoint: .leading,
                                                    endPoint: .trailing
                                                )
                                            )
                                            .frame(width: geometry.size.width * CGFloat(dailyMinutes) / 480)
                                    }
                                    .frame(height: 8)
                                }
                                .frame(height: 8)
                            }
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(Color.white.opacity(0.05))
                                    .backdrop(.thin)
                            )
                            
                            // Score Impact
                            VStack(spacing: 8) {
                                HStack {
                                    Image(systemName: "gauge.high")
                                        .foregroundColor(.green)
                                    
                                    Text("Impact on Daily Score")
                                        .font(.caption)
                                        .foregroundColor(.white)
                                    
                                    Spacer()
                                    
                                    Text(usageScore)
                                        .font(.caption)
                                        .fontWeight(.semibold)
                                        .foregroundColor(.green)
                                }
                            }
                            .padding()
                            .background(Color.green.opacity(0.1))
                            .cornerRadius(12)
                        }
                        .padding()
                        
                        // Recommended Reduction
                        VStack(spacing: 12) {
                            HStack {
                                Image(systemName: "lightbulb.fill")
                                    .foregroundColor(.yellow)
                                
                                Text("Recommendations")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                
                                Spacer()
                            }
                            
                            VStack(alignment: .leading, spacing: 8) {
                                RecommendationItem(
                                    title: "Set Screen Time Limits",
                                    description: "Use iOS Screen Time to limit app usage"
                                )
                                
                                RecommendationItem(
                                    title: "Use App Timers",
                                    description: "Set timers for social media apps"
                                )
                                
                                RecommendationItem(
                                    title: "Device-Free Hours",
                                    description: "Keep your phone away during meals and before bed"
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
                        
                        // Usage Logs
                        VStack(spacing: 12) {
                            HStack {
                                Text("Usage Logs")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                
                                Spacer()
                                
                                Button(action: { showLogSheet = true }) {
                                    Image(systemName: "plus.circle.fill")
                                        .foregroundColor(.blue)
                                }
                            }
                            
                            if usageLogs.isEmpty {
                                Text("No logs yet")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            } else {
                                ForEach(usageLogs, id: \.id) { log in
                                    HStack {
                                        VStack(alignment: .leading) {
                                            Text(log.appName)
                                                .font(.caption)
                                                .foregroundColor(.white)
                                            
                                            Text(log.category)
                                                .font(.caption2)
                                                .foregroundColor(.gray)
                                        }
                                        
                                        Spacer()
                                        
                                        Text("\(log.totalMinutes) min")
                                            .font(.caption)
                                            .foregroundColor(.orange)
                                    }
                                    .padding()
                                    .background(Color.white.opacity(0.05))
                                    .cornerRadius(8)
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
                        
                        Spacer(minLength: 20)
                    }
                }
            }
            .navigationTitle("Phone Usage")
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $showLogSheet) {
                LogUsageSheet(isPresented: $showLogSheet, onSave: { minutes, appName, category in
                    dataManager.logAppUsage(minutes: minutes, appName: appName, category: category)
                    loadUsageLogs()
                })
            }
            .onAppear {
                loadUsageLogs()
            }
        }
    }
    
    private func loadUsageLogs() {
        usageLogs = dataManager.fetchTodayUsageLogs()
        dailyMinutes = Int(usageLogs.reduce(0) { $0 + $1.totalMinutes })
    }
    
    private var usageScore: String {
        let score = max(0, 20 - Double(dailyMinutes) / 30)
        return String(format: "%.1f pts", score)
    }
}

struct RecommendationItem: View {
    let title: String
    let description: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundColor(.white)
            
            Text(description)
                .font(.caption2)
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(8)
        .background(Color.white.opacity(0.05))
        .cornerRadius(8)
    }
}

struct LogUsageSheet: View {
    @Binding var isPresented: Bool
    var onSave: (Int, String, String) -> Void
    
    @State private var minutes: String = ""
    @State private var appName: String = ""
    @State private var category: String = "Social Media"
    
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
                    VStack(spacing: 16) {
                        TextField("App Name", text: $appName)
                            .padding()
                            .background(Color.white.opacity(0.1))
                            .cornerRadius(12)
                            .foregroundColor(.white)
                        
                        TextField("Minutes", text: $minutes)
                            .keyboardType(.numberPad)
                            .padding()
                            .background(Color.white.opacity(0.1))
                            .cornerRadius(12)
                            .foregroundColor(.white)
                        
                        Picker("Category", selection: $category) {
                            Text("Social Media").tag("Social Media")
                            Text("Entertainment").tag("Entertainment")
                            Text("Productivity").tag("Productivity")
                            Text("Games").tag("Games")
                            Text("Other").tag("Other")
                        }
                        .padding()
                        .background(Color.white.opacity(0.1))
                        .cornerRadius(12)
                        
                        Button(action: {
                            if let mins = Int(minutes) {
                                onSave(mins, appName, category)
                                isPresented = false
                            }
                        }) {
                            Text("Log Usage")
                                .font(.headline)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(
                                    LinearGradient(
                                        gradient: Gradient(colors: [.blue, .purple]),
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .cornerRadius(12)
                                .foregroundColor(.white)
                        }
                        .disabled(appName.isEmpty || minutes.isEmpty)
                        .opacity((appName.isEmpty || minutes.isEmpty) ? 0.5 : 1.0)
                        
                        Spacer()
                    }
                    .padding()
                }
            }
            .navigationTitle("Log App Usage")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        isPresented = false
                    }
                    .foregroundColor(.blue)
                }
            }
        }
    }
}

#Preview {
    AppUsageView()
}
