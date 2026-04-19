import Foundation
import Combine
import CoreData

class TodoViewModel: NSObject, ObservableObject {
    @Published var todos: [NSTodo] = []
    @Published var showNewTodoSheet = false
    @Published var newTodoTitle = ""
    @Published var newTodoDescription = ""
    @Published var newTodoDueDate = Date()
    @Published var newTodoPriority = "medium"
    @Published var newTodoCategory = "Work"
    @Published var isRecurring = false
    
    private let dataManager = CoreDataManager.shared
    private let notificationService = NotificationService.shared
    
    override init() {
        super.init()
        fetchTodos()
    }
    
    func fetchTodos() {
        todos = dataManager.fetchTodos()
    }
    
    func createNewTodo() {
        let todo = dataManager.createTodo(
            title: newTodoTitle,
            description: newTodoDescription,
            dueDate: newTodoDueDate,
            priority: newTodoPriority,
            category: newTodoCategory,
            isRecurring: isRecurring
        )
        
        notificationService.scheduleTodoReminder(todoId: todo.id, todoTitle: newTodoTitle, at: newTodoDueDate)
        
        newTodoTitle = ""
        newTodoDescription = ""
        newTodoDueDate = Date()
        newTodoPriority = "medium"
        newTodoCategory = "Work"
        isRecurring = false
        
        fetchTodos()
    }
    
    func toggleTodoCompletion(_ todo: NSTodo) {
        dataManager.completeTodo(todo)
        fetchTodos()
    }
    
    func deleteTodo(_ todo: NSTodo) {
        notificationService.cancelNotification(withIdentifier: todo.id.uuidString)
        dataManager.delete(todo)
        fetchTodos()
    }
    
    func getTodosForToday() -> [NSTodo] {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let tomorrow = calendar.date(byAdding: .day, value: 1, to: today)!
        
        return todos.filter { todo in
            guard let dueDate = todo.dueDate else { return false }
            return dueDate >= today && dueDate < tomorrow
        }
    }
    
    func getTodosForWeek() -> [NSTodo] {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let weekLater = calendar.date(byAdding: .day, value: 7, to: today)!
        
        return todos.filter { todo in
            guard let dueDate = todo.dueDate else { return false }
            return dueDate >= today && dueDate < weekLater
        }
    }
    
    var highPriorityTodos: [NSTodo] {
        todos.filter { $0.priority == "high" && !$0.isCompleted }
    }
    
    var completedTodos: [NSTodo] {
        todos.filter { $0.isCompleted }
    }
    
    var pendingTodos: [NSTodo] {
        todos.filter { !$0.isCompleted }
    }
    
    var completionPercentage: Double {
        let total = todos.count
        guard total > 0 else { return 0 }
        let completed = completedTodos.count
        return Double(completed) / Double(total) * 100
    }
}
