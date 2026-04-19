import SwiftUI

struct HabitsView: View {
    @ObservedObject var viewModel: HabitViewModel
    let notificationService: NotificationService
    @State private var showNewHabitSheet = false
    @State private var selectedTab = 0
    
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
                
                VStack(spacing: 0) {
                    // Tab Selector
                    HStack(spacing: 0) {
                        TabOption(
                            label: "Good Habits",
                            isSelected: selectedTab == 0,
                            action: { selectedTab = 0 }
                        )
                        
                        TabOption(
                            label: "Bad Habits",
                            isSelected: selectedTab == 1,
                            action: { selectedTab = 1 }
                        )
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 12)
                    
                    // Content
                    ScrollView {
                        VStack(spacing: 12) {
                            if selectedTab == 0 {
                                HabitsList(habits: viewModel.goodHabits, viewModel: viewModel)
                            } else {
                                HabitsList(habits: viewModel.badHabits, viewModel: viewModel)
                            }
                        }
                        .padding()
                    }
                    
                    Spacer()
                }
            }
            .navigationTitle("Habits")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: { showNewHabitSheet = true }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.title3)
                            .foregroundColor(.blue)
                    }
                }
            }
            .sheet(isPresented: $showNewHabitSheet) {
                NewHabitSheet(viewModel: viewModel, isPresented: $showNewHabitSheet)
            }
        }
    }
}

struct HabitsList: View {
    let habits: [NSHabit]
    @ObservedObject var viewModel: HabitViewModel
    
    var body: some View {
        if habits.isEmpty {
            VStack(spacing: 12) {
                Image(systemName: "checkmark.circle")
                    .font(.system(size: 48))
                    .foregroundColor(.gray)
                
                Text("No habits yet")
                    .font(.headline)
                    .foregroundColor(.white)
                
                Text("Create your first habit to get started!")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 40)
        } else {
            VStack(spacing: 12) {
                ForEach(habits, id: \.id) { habit in
                    HabitCard(habit: habit, viewModel: viewModel)
                }
            }
        }
    }
}

struct HabitCard: View {
    let habit: NSHabit
    @ObservedObject var viewModel: HabitViewModel
    @State private var showChildHabits = false
    
    var body: some View {
        VStack(spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(habit.name)
                        .font(.headline)
                        .foregroundColor(.white)
                    
                    HStack(spacing: 8) {
                        Label(habit.category, systemImage: "tag.fill")
                            .font(.caption)
                            .foregroundColor(.gray)
                        
                        Spacer()
                        
                        Label("Streak: \(habit.currentStreak)", systemImage: "flame.fill")
                            .font(.caption)
                            .foregroundColor(.orange)
                    }
                }
                
                Spacer()
                
                Button(action: {
                    viewModel.toggleHabitCompletion(habit)
                }) {
                    Image(systemName: habit.isCompleted ? "checkmark.circle.fill" : "circle")
                        .font(.title2)
                        .foregroundColor(habit.isCompleted ? .green : .gray)
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.white.opacity(0.05))
                    
            )
            
            // Child habits if exists
            if let childHabits = habit.childHabits as? Set<NSHabit>, !childHabits.isEmpty {
                VStack(spacing: 8) {
                    ForEach(Array(childHabits).sorted { $0.name < $1.name }, id: \.id) { child in
                        HStack {
                            Text(child.name)
                                .font(.caption)
                                .foregroundColor(.white)
                            
                            Spacer()
                            
                            if let time = child.reminderTime {
                                Text(time, style: .time)
                                    .font(.caption2)
                                    .foregroundColor(.gray)
                            }
                            
                            Button(action: {
                                viewModel.toggleHabitCompletion(child)
                            }) {
                                Image(systemName: child.isCompleted ? "checkmark.circle.fill" : "circle")
                                    .font(.caption)
                                    .foregroundColor(child.isCompleted ? .green : .gray)
                            }
                        }
                        .padding(.vertical, 6)
                        .padding(.horizontal, 4)
                    }
                }
                .padding(.horizontal)
                .padding(.vertical, 8)
                .background(Color.white.opacity(0.02))
                .cornerRadius(12)
            }
        }
    }
}

struct NewHabitSheet: View {
    @ObservedObject var viewModel: HabitViewModel
    @Binding var isPresented: Bool
    @State private var reminderEnabled = false
    
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
                        TextField("Habit Name", text: $viewModel.newHabitName)
                            .padding()
                            .background(Color.white.opacity(0.1))
                            .cornerRadius(12)
                            .foregroundColor(.white)
                        
                        Picker("Category", selection: $viewModel.newHabitCategory) {
                            Text("Health").tag("Health")
                            Text("Fitness").tag("Fitness")
                            Text("Learning").tag("Learning")
                            Text("Social").tag("Social")
                            Text("Productivity").tag("Productivity")
                        }
                        .padding()
                        .background(Color.white.opacity(0.1))
                        .cornerRadius(12)
                        
                        Picker("Habit Type", selection: $viewModel.isGoodHabit) {
                            Text("Good Habit").tag(true)
                            Text("Bad Habit").tag(false)
                        }
                        .pickerStyle(.segmented)
                        .padding()
                        
                        Toggle("Add Reminder", isOn: $reminderEnabled)
                            .padding()
                            .foregroundColor(.white)
                        
                        if reminderEnabled {
                            DatePicker("Reminder Time", selection: $viewModel.reminderTime, displayedComponents: .hourAndMinute)
                                .padding()
                                .foregroundColor(.white)
                        }
                        
                        Button(action: {
                            viewModel.reminderEnabled = reminderEnabled
                            viewModel.createNewHabit()
                            isPresented = false
                        }) {
                            Text("Create Habit")
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
                        .disabled(viewModel.newHabitName.isEmpty)
                        .opacity(viewModel.newHabitName.isEmpty ? 0.5 : 1.0)
                        
                        Spacer()
                    }
                    .padding()
                }
            }
            .navigationTitle("New Habit")
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

struct TabOption: View {
    let label: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack {
                Text(label)
                    .font(.headline)
                    .foregroundColor(isSelected ? .blue : .gray)
                
                if isSelected {
                    Capsule()
                        .fill(LinearGradient(
                            gradient: Gradient(colors: [.blue, .purple]),
                            startPoint: .leading,
                            endPoint: .trailing
                        ))
                        .frame(height: 2)
                }
            }
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    HabitsView(viewModel: HabitViewModel(), notificationService: NotificationService.shared)
}
