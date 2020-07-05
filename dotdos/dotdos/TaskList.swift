//
//  TaskList.swift
//  dotdos
//
//  Created by Gabriela Schirmer Mauricio on 28/06/20.
//  Copyright © 2020 Gabriela Schirmer Mauricio. All rights reserved.
//

import SwiftUI

struct TaskList: View {
    @Environment(\.managedObjectContext) var managedContext
    @FetchRequest(entity: Task.entity(), sortDescriptors: []) var tasks: FetchedResults<Task>
    
    @State var showingAdd = false

    var body: some View {
        NavigationView {
            ZStack {
                if tasks.count == 0 {
                    Text("No tasks for today")
                } else {
                    List {
                        ForEach(tasks, id: \.self) { task in
                            ZStack {
                                TaskRow(task: task)
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
                TaskEditor() { id, title in
                 self.addTask(id: id, title: title)
                 self.showingAdd = false
               }
            }
        }
    }
    
    func addTask(id: UUID, title: String) {
        let newTask = Task(context: managedContext)

        newTask.id = id
        newTask.title = title

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
