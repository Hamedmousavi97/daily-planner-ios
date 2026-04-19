import Foundation
import Combine
import CoreData

class HabitViewModel: NSObject, ObservableObject {
    @Published var habits: [NSHabit] = []
    @Published var selectedHabit: NSHabit?
    @Published var showNewHabitSheet = false
    @Published var newHabitName = ""
    @Published var newHabitCategory = "Health"
    @Published var isGoodHabit = true
    @Published var reminderEnabled = false
    @Published var reminderTime = Date()
    
    private let dataManager = CoreDataManager.shared
    private let notificationService = NotificationService.shared
    private var fetchedResultsController: NSFetchedResultsController<NSHabit>?
    
    override init() {
        super.init()
        setupFetchedResultsController()
        fetchHabits()
    }
    
    private func setupFetchedResultsController() {
        let request = NSFetchRequest<NSHabit>(entityName: "NSHabit")
        request.sortDescriptors = [NSSortDescriptor(keyPath: \NSHabit.name, ascending: true)]
        request.predicate = NSPredicate(format: "parentHabit == nil")
        
        fetchedResultsController = NSFetchedResultsController(
            fetchRequest: request,
            managedObjectContext: dataManager.container.viewContext,
            sectionNameKeyPath: "isGoodHabit",
            cacheName: nil
        )
        
        fetchedResultsController?.delegate = self
    }
    
    func fetchHabits() {
        habits = dataManager.fetchHabits()
    }
    
    func createNewHabit() {
        let habit = dataManager.createHabit(
            name: newHabitName,
            category: newHabitCategory,
            isGoodHabit: isGoodHabit,
            reminderTime: reminderEnabled ? reminderTime : nil
        )
        
        if reminderEnabled {
            notificationService.scheduleHabitReminder(habitId: habit.id, habitName: newHabitName, at: reminderTime)
        }
        
        newHabitName = ""
        newHabitCategory = "Health"
        isGoodHabit = true
        reminderEnabled = false
        reminderTime = Date()
        
        fetchHabits()
    }
    
    func toggleHabitCompletion(_ habit: NSHabit) {
        if habit.isCompleted {
            dataManager.uncompleteHabit(habit)
        } else {
            dataManager.completeHabit(habit)
        }
        fetchHabits()
    }
    
    func deleteHabit(_ habit: NSHabit) {
        notificationService.cancelNotification(withIdentifier: habit.id.uuidString)
        dataManager.delete(habit)
        fetchHabits()
    }
    
    func addChildHabit(to parentHabit: NSHabit, name: String, reminderTime: Date?) {
        let childHabit = dataManager.createHabit(
            name: name,
            category: parentHabit.category,
            isGoodHabit: parentHabit.isGoodHabit,
            reminderTime: reminderTime,
            parentHabitId: parentHabit.id
        )
        
        if let reminderTime = reminderTime {
            notificationService.scheduleHabitReminder(habitId: childHabit.id, habitName: name, at: reminderTime)
        }
        
        fetchHabits()
    }
    
    var goodHabits: [NSHabit] {
        habits.filter { $0.isGoodHabit }
    }
    
    var badHabits: [NSHabit] {
        habits.filter { !$0.isGoodHabit }
    }
    
    var completionPercentage: Double {
        let total = habits.count
        guard total > 0 else { return 0 }
        let completed = habits.filter { $0.isCompleted }.count
        return Double(completed) / Double(total) * 100
    }
}

// MARK: - NSFetchedResultsControllerDelegate
extension HabitViewModel: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        fetchHabits()
    }
}
