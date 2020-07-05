//
//  TaskList.swift
//  dotdos
//
//  Created by Gabriela Schirmer Mauricio on 28/06/20.
//  Copyright © 2020 Gabriela Schirmer Mauricio. All rights reserved.
//

import SwiftUI
import CoreData

struct TaskList: View {
    @Environment(\.managedObjectContext) var managedContext
    @State var showingAdd = false
    var listTitle: String
    var taskRequest: FetchRequest<Task>
    var tasks: FetchedResults<Task> { taskRequest.wrappedValue }
    
    init(_ filter: NSPredicate?) {
        taskRequest = FetchRequest<Task>(entity: Task.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Task.dueDate, ascending: true)], predicate: filter)
        if filter != nil {
            listTitle = "TODAY"
        } else {
            listTitle = "TASKS"
        }
    }
    
    func update(_ result : FetchedResults<Task>)-> [[Task]] {
        return  Dictionary(grouping: result){ (task: Task) in task.dueDate }.values.sorted() { DateTransform.getDateFromString($0[0].dueDate!) < DateTransform.getDateFromString($1[0].dueDate!) }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                if tasks.isEmpty {
                    Text(listTitle == "TODAY" ? "No tasks for today" : "No tasks added")
                } else {
                    List {
                        if listTitle == "TODAY" {
                            ForEach(tasks, id: \.self) { task in
                                TaskRow(task: task) { task, newStatus in
                                    self.updateTask(task: task, newStatus: newStatus)
                                }
                            }
                        } else {
                            ForEach(update(tasks), id: \.self) { (section: [Task]) in
                                Section(header: Text(DateTransform.getDateLabel(section[0].dueDate ?? ""))
                                    .font(.system(size: 12, weight: .semibold))) {
                                    ForEach(section, id: \.self) { task in
                                        TaskRow(task: task) { task, newStatus in
                                            self.updateTask(task: task, newStatus: newStatus)
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
            .navigationBarItems(trailing: Button(action: {
                self.showingAdd.toggle()
            }) {
                Image(systemName: "plus.circle.fill")
            })
            .navigationBarTitle("\(listTitle)", displayMode: .inline)
            .sheet(isPresented: $showingAdd) {
                TaskEditor() { id, title, dueDate in
                 self.addTask(id: id, title: title, dueDate: dueDate)
                 self.showingAdd = false
               }
            }
        }
    }
    
    func updateTask(task: Task, newStatus: Status) {
        managedContext.performAndWait {
            task.status = newStatus.rawValue
            saveContext()
        }
    }
    
    func addTask(id: UUID, title: String, dueDate: Date) {
        let newTask = Task(context: managedContext)

        newTask.id = id
        newTask.title = title
        newTask.dueDate = DateTransform.getStringFromDate(dueDate)

        saveContext()
    }
    
    func saveContext() {
        do {
            try managedContext.save()
        } catch {
            print("Error saving managed object context: \(error)")
        }
    }
}

struct TaskList_Previews: PreviewProvider {
    static var previews: some View {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        return TaskList(NSPredicate(format: "dueDate == %@", DateTransform.getStringFromDate(Date()) as CVarArg)).environment(\.managedObjectContext, context).environment(\.colorScheme, .dark)
    }
}
