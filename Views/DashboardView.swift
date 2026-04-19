import SwiftUI

struct DashboardView: View {
    @ObservedObject var viewModel: DashboardViewModel
    @State private var refreshing = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Background
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
                        // Header
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Good Morning")
                                .font(.title2)
                                .foregroundColor(.gray)
                            
                            Text(Date(), style: .date)
                                .font(.headline)
                                .foregroundColor(.white)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                        
                        // Daily Score Card
                        VStack(spacing: 12) {
                            HStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Today's Score")
                                        .font(.headline)
                                        .foregroundColor(.white)
                                    
                                    Text(viewModel.performanceLevel)
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                }
                                
                                Spacer()
                                
                                ZStack {
                                    Circle()
                                        .stroke(Color.white.opacity(0.1), lineWidth: 8)
                                        .frame(width: 80, height: 80)
                                    
                                    Circle()
                                        .trim(from: 0, to: viewModel.dailyScore / 100)
                                        .stroke(
                                            LinearGradient(
                                                gradient: Gradient(colors: [.blue, .purple]),
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            ),
                                            style: StrokeStyle(lineWidth: 8, lineCap: .round)
                                        )
                                        .frame(width: 80, height: 80)
                                        .rotationEffect(.degrees(-90))
                                    
                                    VStack {
                                        Text(String(format: "%.0f", viewModel.dailyScore))
                                            .font(.title2)
                                            .fontWeight(.bold)
                                            .foregroundColor(.white)
                                        Text("%")
                                            .font(.caption)
                                            .foregroundColor(.gray)
                                    }
                                }
                            }
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(Color.white.opacity(0.05))
                                    .backdrop(.thin)
                            )
                        }
                        .padding(.horizontal)
                        
                        // Motivation Quote
                        VStack {
                            Text(viewModel.motivation)
                                .font(.headline)
                                .foregroundColor(.white)
                                .lineLimit(3)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color.purple.opacity(0.2))
                                .backdrop(.thin)
                        )
                        .padding(.horizontal)
                        
                        // Statistics
                        VStack(spacing: 12) {
                            Text("Today's Progress")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            HStack(spacing: 12) {
                                StatisticCard(
                                    label: "Habits",
                                    value: "\(viewModel.todayHabitsCompleted)/\(viewModel.todayHabitsTotal)",
                                    icon: "checkmark.circle.fill",
                                    color: .green
                                )
                                
                                StatisticCard(
                                    label: "Todos",
                                    value: "\(viewModel.todayTodosCompleted)/\(viewModel.todayTodosTotal)",
                                    icon: "list.bullet.fill",
                                    color: .blue
                                )
                                
                                StatisticCard(
                                    label: "Usage",
                                    value: "\(viewModel.appUsageMinutes)m",
                                    icon: "iphone.fill",
                                    color: .orange
                                )
                            }
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color.white.opacity(0.05))
                                .backdrop(.thin)
                        )
                        .padding(.horizontal)
                        
                        // Weather & News Section
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Daily Briefing")
                                .font(.headline)
                                .foregroundColor(.white)
                            
                            HStack(spacing: 12) {
                                Image(systemName: "sun.max.fill")
                                    .foregroundColor(.yellow)
                                Text(viewModel.weatherData)
                                    .foregroundColor(.white)
                                Spacer()
                            }
                            .padding()
                            .background(Color.white.opacity(0.05))
                            .cornerRadius(12)
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Text("News")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                                
                                ForEach(viewModel.newsItems.prefix(3), id: \.self) { news in
                                    HStack(spacing: 8) {
                                        Image(systemName: "newspaper.fill")
                                            .font(.caption)
                                            .foregroundColor(.blue)
                                        Text(news)
                                            .font(.caption)
                                            .foregroundColor(.white)
                                            .lineLimit(2)
                                    }
                                    .padding(.vertical, 4)
                                }
                            }
                            .padding()
                            .background(Color.white.opacity(0.05))
                            .cornerRadius(12)
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color.white.opacity(0.05))
                                .backdrop(.thin)
                        )
                        .padding(.horizontal)
                        
                        Spacer(minLength: 20)
                    }
                    .padding(.vertical)
                }
                .refreshable {
                    viewModel.refreshDashboard()
                }
            }
            .navigationTitle("Dashboard")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct StatisticCard: View {
    let label: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(color)
            
            Text(value)
                .font(.headline)
                .foregroundColor(.white)
            
            Text(label)
                .font(.caption)
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white.opacity(0.05))
                .backdrop(.thin)
        )
    }
}

#Preview {
    DashboardView(
        viewModel: DashboardViewModel(
            habitViewModel: HabitViewModel(),
            todoViewModel: TodoViewModel()
        )
    )
}
