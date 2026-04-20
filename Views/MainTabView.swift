import SwiftUI

struct MainTabView: View {
    @StateObject private var habitViewModel = HabitViewModel()
    @StateObject private var todoViewModel = TodoViewModel()
    @StateObject private var dashboardViewModel: DashboardViewModel
    @Environment(\.colorScheme) var colorScheme
    
    init() {
        let habVM = HabitViewModel()
        let todoVM = TodoViewModel()
        _habitViewModel = StateObject(wrappedValue: habVM)
        _todoViewModel = StateObject(wrappedValue: todoVM)
        _dashboardViewModel = StateObject(wrappedValue: DashboardViewModel(habitViewModel: habVM, todoViewModel: todoVM))
    }
    
    var body: some View {
        TabView {
            // Dashboard Tab
            DashboardView(viewModel: dashboardViewModel)
                .tabItem {
                    Label("Dashboard", systemImage: "rectangle.grid.1x2.fill")
                }
            
            // Habits Tab
            HabitsView(viewModel: habitViewModel, notificationService: NotificationService.shared)
                .tabItem {
                    Label("Habits", systemImage: "checkmark.circle.fill")
                }
            
            // Todos Tab
            TodosView(viewModel: todoViewModel)
                .tabItem {
                    Label("Todos", systemImage: "list.bullet.clipboard.fill")
                }
            
            // Phone Usage Tab
            AppUsageView()
                .tabItem {
                    Label("Usage", systemImage: "iphone")
                }
            
            // Settings Tab
            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
        }
        .background(
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.1, green: 0.1, blue: 0.12),
                    Color(red: 0.12, green: 0.12, blue: 0.15)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
        )
        .preferredColorScheme(.dark)
    }
}

#Preview {
    MainTabView()
}
