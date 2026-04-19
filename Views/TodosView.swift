import SwiftUI

struct TodosView: View {
    @ObservedObject var viewModel: TodoViewModel
    @State private var showNewTodoSheet = false
    @State private var selectedFilter = 0
    
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
                    // Filter Tabs
                    HStack(spacing: 12) {
                        FilterTab(label: "All", isSelected: selectedFilter == 0, action: { selectedFilter = 0 })
                        FilterTab(label: "Today", isSelected: selectedFilter == 1, action: { selectedFilter = 1 })
                        FilterTab(label: "High Priority", isSelected: selectedFilter == 2, action: { selectedFilter = 2 })
                        Spacer()
                    }
                    .padding()
                    
                    // Content
                    ScrollView {
                        VStack(spacing: 12) {
                            if selectedFilter == 0 {
                                TodosList(todos: viewModel.todos, viewModel: viewModel)
                            } else if selectedFilter == 1 {
                                TodosList(todos: viewModel.getTodosForToday(), viewModel: viewModel)
                            } else {
                                TodosList(todos: viewModel.highPriorityTodos, viewModel: viewModel)
                            }
                        }
                        .padding()
                    }
                }
            }
            .navigationTitle("Todos")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: { showNewTodoSheet = true }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.title3)
                            .foregroundColor(.blue)
                    }
                }
            }
            .sheet(isPresented: $showNewTodoSheet) {
                NewTodoSheet(viewModel: viewModel, isPresented: $showNewTodoSheet)
            }
        }
    }
}

struct TodosList: View {
    let todos: [NSTodo]
    @ObservedObject var viewModel: TodoViewModel
    
    var body: some View {
        if todos.isEmpty {
            VStack(spacing: 12) {
                Image(systemName: "checkmark.square")
                    .font(.system(size: 48))
                    .foregroundColor(.gray)
                
                Text("No todos")
                    .font(.headline)
                    .foregroundColor(.white)
                
                Text("All done or no todos yet!")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 40)
        } else {
            VStack(spacing: 12) {
                ForEach(todos, id: \.id) { todo in
                    TodoCard(todo: todo, viewModel: viewModel)
                }
            }
        }
    }
}

struct TodoCard: View {
    let todo: NSTodo
    @ObservedObject var viewModel: TodoViewModel
    @State private var showDeleteAlert = false
    
    var body: some View {
        HStack(spacing: 12) {
            Button(action: {
                viewModel.toggleTodoCompletion(todo)
            }) {
                Image(systemName: todo.isCompleted ? "checkmark.circle.fill" : "circle")
                    .font(.title3)
                    .foregroundColor(todo.isCompleted ? .green : .gray)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(todo.title)
                    .font(.headline)
                    .foregroundColor(.white)
                    .strikethrough(todo.isCompleted, color: .gray)
                
                if let description = todo.todoDescription {
                    Text(description)
                        .font(.caption)
                        .foregroundColor(.gray)
                        .lineLimit(1)
                }
                
                HStack(spacing: 8) {
                    Label(todo.category, systemImage: "folder.fill")
                        .font(.caption2)
                        .foregroundColor(.blue)
                    
                    Label(todo.priority, systemImage: "exclamationmark.circle.fill")
                        .font(.caption2)
                        .foregroundColor(priorityColor(todo.priority))
                    
                    if let dueDate = todo.dueDate {
                        Label(dueDate.formatted(date: .abbreviated, time: .omitted), systemImage: "calendar")
                            .font(.caption2)
                            .foregroundColor(.orange)
                    }
                }
            }
            
            Spacer()
            
            Menu {
                Button(role: .destructive) {
                    showDeleteAlert = true
                } label: {
                    Label("Delete", systemImage: "trash")
                }
            } label: {
                Image(systemName: "ellipsis")
                    .foregroundColor(.gray)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white.opacity(0.05))
                
        )
        .alert("Delete Todo", isPresented: $showDeleteAlert) {
            Button("Delete", role: .destructive) {
                viewModel.deleteTodo(todo)
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("Are you sure you want to delete this todo?")
        }
    }
    
    func priorityColor(_ priority: String) -> Color {
        switch priority {
        case "high": return .red
        case "medium": return .yellow
        default: return .green
        }
    }
}

struct NewTodoSheet: View {
    @ObservedObject var viewModel: TodoViewModel
    @Binding var isPresented: Bool
    
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
                        TextField("Todo Title", text: $viewModel.newTodoTitle)
                            .padding()
                            .background(Color.white.opacity(0.1))
                            .cornerRadius(12)
                            .foregroundColor(.white)
                        
                        TextField("Description", text: $viewModel.newTodoDescription)
                            .padding()
                            .background(Color.white.opacity(0.1))
                            .cornerRadius(12)
                            .foregroundColor(.white)
                            .frame(height: 80)
                        
                        DatePicker("Due Date", selection: $viewModel.newTodoDueDate)
                            .padding()
                            .foregroundColor(.white)
                        
                        Picker("Priority", selection: $viewModel.newTodoPriority) {
                            Text("Low").tag("low")
                            Text("Medium").tag("medium")
                            Text("High").tag("high")
                        }
                        .padding()
                        .background(Color.white.opacity(0.1))
                        .cornerRadius(12)
                        
                        Picker("Category", selection: $viewModel.newTodoCategory) {
                            Text("Work").tag("Work")
                            Text("Personal").tag("Personal")
                            Text("Shopping").tag("Shopping")
                            Text("Health").tag("Health")
                        }
                        .padding()
                        .background(Color.white.opacity(0.1))
                        .cornerRadius(12)
                        
                        Toggle("Recurring Daily", isOn: $viewModel.isRecurring)
                            .padding()
                            .foregroundColor(.white)
                        
                        Button(action: {
                            viewModel.createNewTodo()
                            isPresented = false
                        }) {
                            Text("Create Todo")
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
                        .disabled(viewModel.newTodoTitle.isEmpty)
                        .opacity(viewModel.newTodoTitle.isEmpty ? 0.5 : 1.0)
                        
                        Spacer()
                    }
                    .padding()
                }
            }
            .navigationTitle("New Todo")
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

struct FilterTab: View {
    let label: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(label)
                .font(.caption)
                .fontWeight(.semibold)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(
                    isSelected ? 
                        AnyShapeStyle(LinearGradient(gradient: Gradient(colors: [.blue, .purple]), startPoint: .leading, endPoint: .trailing)) as AnyShapeStyle
                        : AnyShapeStyle(Color.white.opacity(0.1))
                )
                .foregroundColor(.white)
                .cornerRadius(8)
        }
    }
}

#Preview {
    TodosView(viewModel: TodoViewModel())
}
