import Foundation
import CoreData

// MARK: - Habit Model
class NSHabit: NSManagedObject {
    @NSManaged var id: UUID
    @NSManaged var name: String
    @NSManaged var category: String
    @NSManaged var isGoodHabit: Bool
    @NSManaged var createdDate: Date
    @NSManaged var currentStreak: Int32
    @NSManaged var bestStreak: Int32
    @NSManaged var timesCompleted: Int32
    @NSManaged var isCompleted: Bool
    @NSManaged var completedDate: Date?
    @NSManaged var reminderTime: Date?
    @NSManaged var hasReminder: Bool
    @NSManaged var parentHabit: NSHabit?
    @NSManaged var childHabits: NSSet
    @NSManaged var externalAppLink: String?
    @NSManaged var notes: String?
}

// MARK: - Todo Model
class NSTodo: NSManagedObject {
    @NSManaged var id: UUID
    @NSManaged var title: String
    @NSManaged var todoDescription: String?
    @NSManaged var isCompleted: Bool
    @NSManaged var createdDate: Date
    @NSManaged var dueDate: Date?
    @NSManaged var isRecurring: Bool
    @NSManaged var priority: String // "high", "medium", "low"
    @NSManaged var category: String
    @NSManaged var completedDate: Date?
}

// MARK: - Daily Score Model
class NSDailyScore: NSManagedObject {
    @NSManaged var id: UUID
    @NSManaged var date: Date
    @NSManaged var totalScore: Double
    @NSManaged var habitsCompleted: Int32
    @NSManaged var habitsTotal: Int32
    @NSManaged var todosCompleted: Int32
    @NSManaged var todosTotal: Int32
    @NSManaged var appUsageReduction: Double
    @NSManaged var notes: String?
}

// MARK: - App Usage Log
class NSAppUsageLog: NSManagedObject {
    @NSManaged var id: UUID
    @NSManaged var date: Date
    @NSManaged var totalMinutes: Int32
    @NSManaged var appName: String
    @NSManaged var category: String
}

// MARK: - Health Integration
class NSHealthEntry: NSManagedObject {
    @NSManaged var id: UUID
    @NSManaged var date: Date
    @NSManaged var entryType: String // "journal", "meditation", "water"
    @NSManaged var value: Double
    @NSManaged var notes: String?
}
