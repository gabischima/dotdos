//
//  TaskRow.swift
//  dotdos
//
//  Created by Gabriela Schirmer Mauricio on 28/06/20.
//  Copyright © 2020 Gabriela Schirmer Mauricio. All rights reserved.
//

import SwiftUI

struct TaskRow: View {
    @State private var dragOffset = CGSize.zero
    var task: Task
    let onChangeStatus: (Task, Status) -> Void

    var iconOpacity: Double {
        let maxSize = UIScreen.main.bounds.width / 2
        return Double(dragOffset.width / maxSize)
    }
    
    var body: some View {
        ZStack(alignment: .leading) {
            HStack {
                Image(systemName: "\(task.status == Status.done.rawValue ? "xmark" : "checkmark").circle.fill")
                    .imageScale(.large)
                    .accessibility(label: Text("Mark task as done"))
                    .opacity(iconOpacity)
                Spacer()
            }
            HStack {
                ZStack {
                    Circle()
                        .frame(width: 5, height: 5)
                    if task.status == Status.done.rawValue {
                        Image(systemName: "xmark")
                            .font(.system(size: 20))
                    }
                }
                .frame(width: 24, height: 24)
                
                VStack(alignment: .leading) {
                    task.title.map(Text.init)
                        .foregroundColor(.primary)
                        .font(.system(size: 13, weight: .semibold))
                }
                
                Spacer()
//                Image(systemName: "chevron.right")
//                    .font(.system(size: 12, weight: .bold))
//                    .accessibility(label: Text("Go to task detail"))
            }
            .background(Color(UIColor.systemBackground))
            .offset(x: self.dragOffset.width)
            .animation(.spring())
            .gesture(DragGesture()
                .onChanged({ (value) in
                    self.dragOffset = value.translation
                })
                .onEnded({ (value) in
                    if self.dragOffset.width > (UIScreen.main.bounds.width / 2) {
                        let newStatus = self.task.status == Status.done.rawValue ? Status.toDo : Status.done
                        self.onChangeStatus(self.task, newStatus)
                    }
                    self.dragOffset = .zero
                })
            )
        }
    }
}

struct TaskRow_Previews: PreviewProvider {
    static var previews: some View {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        return TaskRow(task: Task(context: context)){ (task, newStatus) in }.environment(\.managedObjectContext, context).environment(\.colorScheme, .light).previewLayout(.fixed(width: 375, height: 24))
    }
}
