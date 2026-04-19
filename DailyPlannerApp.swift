import SwiftUI

@main
struct DailyPlannerApp: App {
    @StateObject private var dataManager = CoreDataManager.shared
    
    var body: some Scene {
        WindowGroup {
            MainTabView()
                .environment(\.managedObjectContext, dataManager.container.viewContext)
        }
    }
}
