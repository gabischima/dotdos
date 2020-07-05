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
    @FetchRequest(entity: Task.entity(), sortDescriptors: [], predicate: NSPredicate(format: "dueDate == %@", getStringFromDate(Date()) as CVarArg)) var tasks: FetchedResults<Task>
    
    static func getStringFromDate(_ date: Date) -> String {
        let format = DateFormatter()
        format.dateFormat = "YYYY-MM-dd"
        let formattedDate = format.string(from: date)
        return formattedDate
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                if tasks.count == 0 {
                    Text("No tasks for today")
                } else {
                    List {
                        ForEach(tasks, id: \.self) { task in
                            ZStack {
                                TaskRow(task: task) { task, newStatus in
                                    self.updateTask(task: task, newStatus: newStatus)
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
            .navigationBarTitle("TODAY", displayMode: .inline)
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
        newTask.dueDate = TaskList.getStringFromDate(dueDate)

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
        return TaskList().environment(\.managedObjectContext, context).environment(\.colorScheme, .light)
    }
}
