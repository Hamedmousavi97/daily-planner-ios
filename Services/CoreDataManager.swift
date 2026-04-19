import Foundation
import CoreData

class CoreDataManager: ObservableObject {
    static let shared = CoreDataManager()
    
    let container: NSPersistentContainer
    
    init() {
        container = NSPersistentContainer(name: "DailyPlanner")
        container.loadPersistentStores { description, error in
            if let error = error as NSError? {
                fatalError("Core Data Error: \(error), \(error.userInfo)")
            }
        }
        container.viewContext.automaticallyMergesChangesFromTheOther = true
    }
    
    // MARK: - Habit Operations
    func createHabit(name: String, category: String, isGoodHabit: Bool, 
                    reminderTime: Date? = nil, parentHabitId: UUID? = nil) -> NSHabit {
        let newHabit = NSHabit(context: container.viewContext)
        newHabit.id = UUID()
        newHabit.name = name
        newHabit.category = category
        newHabit.isGoodHabit = isGoodHabit
        newHabit.createdDate = Date()
        newHabit.currentStreak = 0
        newHabit.bestStreak = 0
        newHabit.timesCompleted = 0
        newHabit.isCompleted = false
        newHabit.reminderTime = reminderTime
        newHabit.hasReminder = reminderTime != nil
        
        if let parentId = parentHabitId {
            if let parent = fetchHabitById(parentId) {
                newHabit.parentHabit = parent
            }
        }
        
        save()
        return newHabit
    }
    
    func fetchHabits() -> [NSHabit] {
        let request = NSFetchRequest<NSHabit>(entityName: "NSHabit")
        request.predicate = NSPredicate(format: "parentHabit == nil") // Only fetch top-level habits
        
        do {
            return try container.viewContext.fetch(request)
        } catch {
            print("Error fetching habits: \(error)")
            return []
        }
    }
    
    func fetchHabitById(_ id: UUID) -> NSHabit? {
        let request = NSFetchRequest<NSHabit>(entityName: "NSHabit")
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        
        do {
            return try container.viewContext.fetch(request).first
        } catch {
            print("Error fetching habit: \(error)")
            return nil
        }
    }
    
    func completeHabit(_ habit: NSHabit) {
        habit.isCompleted = true
        habit.completedDate = Date()
        habit.timesCompleted += 1
        habit.currentStreak += 1
        
        if habit.bestStreak < habit.currentStreak {
            habit.bestStreak = habit.currentStreak
        }
        
        save()
    }
    
    func uncompleteHabit(_ habit: NSHabit) {
        habit.isCompleted = false
        habit.completedDate = nil
        habit.currentStreak = max(0, habit.currentStreak - 1)
        
        save()
    }
    
    // MARK: - Todo Operations
    func createTodo(title: String, description: String? = nil, dueDate: Date? = nil,
                   priority: String = "medium", category: String = "Work",
                   isRecurring: Bool = false) -> NSTodo {
        let newTodo = NSTodo(context: container.viewContext)
        newTodo.id = UUID()
        newTodo.title = title
        newTodo.description = description
        newTodo.dueDate = dueDate
        newTodo.priority = priority
        newTodo.category = category
        newTodo.isRecurring = isRecurring
        newTodo.createdDate = Date()
        newTodo.isCompleted = false
        
        save()
        return newTodo
    }
    
    func fetchTodos() -> [NSTodo] {
        let request = NSFetchRequest<NSTodo>(entityName: "NSTodo")
        request.sortDescriptors = [NSSortDescriptor(keyPath: \NSTodo.dueDate, ascending: true)]
        
        do {
            return try container.viewContext.fetch(request)
        } catch {
            print("Error fetching todos: \(error)")
            return []
        }
    }
    
    func completeTodo(_ todo: NSTodo) {
        todo.isCompleted = true
        todo.completedDate = Date()
        
        // If recurring, create next instance
        if todo.isRecurring {
            let newTodo = NSTodo(context: container.viewContext)
            newTodo.id = UUID()
            newTodo.title = todo.title
            newTodo.description = todo.description
            newTodo.priority = todo.priority
            newTodo.category = todo.category
            newTodo.isRecurring = true
            newTodo.createdDate = Date()
            newTodo.isCompleted = false
            
            // Schedule for next day
            if let dueDate = todo.dueDate {
                newTodo.dueDate = Calendar.current.date(byAdding: .day, value: 1, to: dueDate)
            } else {
                newTodo.dueDate = Calendar.current.date(byAdding: .day, value: 1, to: Date())
            }
        }
        
        save()
    }
    
    // MARK: - Daily Score Operations
    func calculateAndSaveDailyScore() {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        
        let habits = fetchHabits()
        let todos = fetchTodos()
        
        let habitCount = habits.count
        let completedHabits = habits.filter { $0.isCompleted }.count
        
        let todayTodos = todos.filter { todo in
            guard let dueDate = todo.dueDate else { return false }
            return calendar.isDate(dueDate, inSameDayAs: today)
        }
        
        let completedTodos = todayTodos.filter { $0.isCompleted }.count
        
        let habitScore = habitCount > 0 ? Double(completedHabits) / Double(habitCount) * 50 : 0
        let todoScore = todayTodos.count > 0 ? Double(completedTodos) / Double(todayTodos.count) * 30 : 0
        let appUsageScore = 20.0 // Default
        
        let totalScore = habitScore + todoScore + appUsageScore
        
        // Check if score already exists for today
        let request = NSFetchRequest<NSDailyScore>(entityName: "NSDailyScore")
        request.predicate = NSPredicate(format: "date > %@", today as NSDate)
        
        if let existingScore = (try? container.viewContext.fetch(request))?.first {
            existingScore.totalScore = totalScore
            existingScore.habitsCompleted = Int32(completedHabits)
            existingScore.habitsTotal = Int32(habitCount)
            existingScore.todosCompleted = Int32(completedTodos)
            existingScore.todosTotal = Int32(todayTodos.count)
        } else {
            let newScore = NSDailyScore(context: container.viewContext)
            newScore.id = UUID()
            newScore.date = today
            newScore.totalScore = totalScore
            newScore.habitsCompleted = Int32(completedHabits)
            newScore.habitsTotal = Int32(habitCount)
            newScore.todosCompleted = Int32(completedTodos)
            newScore.todosTotal = Int32(todayTodos.count)
        }
        
        save()
    }
    
    // MARK: - App Usage Operations
    func logAppUsage(minutes: Int, appName: String, category: String) {
        let log = NSAppUsageLog(context: container.viewContext)
        log.id = UUID()
        log.date = Date()
        log.totalMinutes = Int32(minutes)
        log.appName = appName
        log.category = category
        
        save()
    }
    
    func fetchTodayUsageLogs() -> [NSAppUsageLog] {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        
        let request = NSFetchRequest<NSAppUsageLog>(entityName: "NSAppUsageLog")
        request.predicate = NSPredicate(format: "date > %@", today as NSDate)
        
        do {
            return try container.viewContext.fetch(request)
        } catch {
            print("Error fetching usage logs: \(error)")
            return []
        }
    }
    
    // MARK: - Generic Operations
    func save() {
        if container.viewContext.hasChanges {
            do {
                try container.viewContext.save()
            } catch {
                print("Error saving context: \(error)")
            }
        }
    }
    
    func delete(_ object: NSManagedObject) {
        container.viewContext.delete(object)
        save()
    }
}
