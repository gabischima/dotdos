//
//  TaskEditor.swift
//  dotdos
//
//  Created by Gabriela Schirmer Mauricio on 28/06/20.
//  Copyright © 2020 Gabriela Schirmer Mauricio. All rights reserved.
//

import SwiftUI

struct TaskEditor: View {
    @State var id: UUID = UUID()
    @State var title: String = ""
    @State var dueDate: Date = Date()
    let onComplete: (UUID, String, Date) -> Void

    var body: some View {
        NavigationView {
            List {
                TextField("What do you have to do?", text: $title).font(.system(size: 14, weight: .regular))
                VStack(alignment: .leading) {
                    Text("When do you want to do it?").bold()
                    DatePicker(selection: $dueDate, displayedComponents: .date) {
                        Text("When do you want to do it?")
                    }
                    .labelsHidden()
                }
            }
            .navigationBarTitle("NEW TASK", displayMode: .inline)
            .navigationBarItems(trailing: Button("Done") {
                self.addTaskAction()
            }.disabled(title == "")).font(.system(size: 14, weight: .bold))
        }
    }

    private func addTaskAction() {
        onComplete(id, title, dueDate)
    }
}

struct TaskEditor_Previews: PreviewProvider {
    static var previews: some View {
        TaskEditor { (id, title, date) in }
    }
}
