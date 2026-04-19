import Foundation
import Combine

class DashboardViewModel: ObservableObject {
    @Published var dailyScore: Double = 0
    @Published var weatherData: String = ""
    @Published var newsItems: [String] = []
    @Published var todayHabitsCompleted: Int = 0
    @Published var todayHabitsTotal: Int = 0
    @Published var todayTodosCompleted: Int = 0
    @Published var todayTodosTotal: Int = 0
    @Published var appUsageMinutes: Int = 0
    @Published var motivation: String = ""
    
    private let dataManager = CoreDataManager.shared
    private let habitViewModel: HabitViewModel
    private let todoViewModel: TodoViewModel
    
    init(habitViewModel: HabitViewModel, todoViewModel: TodoViewModel) {
        self.habitViewModel = habitViewModel
        self.todoViewModel = todoViewModel
        
        calculateDailyMetrics()
        fetchWeatherData()
        fetchNewsData()
    }
    
    func calculateDailyMetrics() {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        
        // Calculate habits
        todayHabitsTotal = habitViewModel.habits.count
        todayHabitsCompleted = habitViewModel.habits.filter { $0.isCompleted }.count
        
        // Calculate todos
        let todayTodos = todoViewModel.getTodosForToday()
        todayTodosTotal = todayTodos.count
        todayTodosCompleted = todayTodos.filter { $0.isCompleted }.count
        
        // Calculate app usage
        let usageLogs = dataManager.fetchTodayUsageLogs()
        appUsageMinutes = Int(usageLogs.reduce(0) { $0 + $1.totalMinutes })
        
        // Calculate daily score
        let habitScore = todayHabitsTotal > 0 ? Double(todayHabitsCompleted) / Double(todayHabitsTotal) * 40 : 0
        let todoScore = todayTodosTotal > 0 ? Double(todayTodosCompleted) / Double(todayTodosTotal) * 40 : 0
        let appUsageScore = appUsageMinutes > 0 ? max(0, 20 - Double(appUsageMinutes) / 30) : 20
        
        dailyScore = max(0, min(100, habitScore + todoScore + appUsageScore))
        
        // Generate motivation
        generateMotivation()
    }
    
    func fetchWeatherData() {
        // In a real app, you would call a weather API
        // For now, we'll use mock data
        weatherData = "Sunny, 72°F"
    }
    
    func fetchNewsData() {
        // In a real app, you would call a news API
        // For now, we'll use mock data
        newsItems = [
            "Tech: New iOS features released",
            "Health: Daily exercise reduces stress",
            "Productivity: 2-minute rule boosts habits",
            "Wellness: Importance of sleep schedules"
        ]
    }
    
    func generateMotivation() {
        let score = dailyScore
        
        if score >= 90 {
            motivation = "🌟 Excellent! You're crushing your goals today!"
        } else if score >= 75 {
            motivation = "💪 Great job! Keep up the momentum!"
        } else if score >= 60 {
            motivation = "👍 Good progress! You're on the right track!"
        } else if score >= 45 {
            motivation = "🎯 You can do it! Focus on your top priorities!"
        } else {
            motivation = "🚀 Let's turn it around! Start with one small win!"
        }
    }
    
    func refreshDashboard() {
        habitViewModel.fetchHabits()
        todoViewModel.fetchTodos()
        calculateDailyMetrics()
        fetchWeatherData()
        fetchNewsData()
    }
    
    var performanceLevel: String {
        if dailyScore >= 80 { return "Excellent" }
        else if dailyScore >= 60 { return "Good" }
        else if dailyScore >= 40 { return "Fair" }
        else { return "Needs Work" }
    }
}
