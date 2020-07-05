//
//  TaskEditor.swift
//  dotdos
//
//  Created by Gabriela Schirmer Mauricio on 28/06/20.
//  Copyright © 2020 Gabriela Schirmer Mauricio. All rights reserved.
//

import SwiftUI

struct TaskEditor: View {
    @State var id = UUID()
    @State var title = ""
    let onComplete: (UUID, String) -> Void

    var body: some View {
        NavigationView {
            List {
                TextField("What do you have to do?", text: $title).font(.system(size: 14, weight: .regular))
            }
            .navigationBarTitle("NEW TASK", displayMode: .inline)
            .navigationBarItems(trailing: Button("Done") {
                self.addTaskAction()
            }.disabled(title == "")).font(.system(size: 14, weight: .bold))
        }
    }

    private func addTaskAction() {
        onComplete(id, title)
    }
}

struct TaskEditor_Previews: PreviewProvider {
    static var previews: some View {
        TaskEditor { (id, title) in }
    }
}
