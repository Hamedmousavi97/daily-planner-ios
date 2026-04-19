import SwiftUI

@main
struct DailyPlannerApp: App {
    let dataManager = CoreDataManager.shared
    
    var body: some Scene {
        WindowGroup {
            MainTabView()
                .environment(\.managedObjectContext, dataManager.container.viewContext)
        }
    }
}
