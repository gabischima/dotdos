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

    var body: some View {
        ZStack(alignment: .leading) {
            HStack {
                Image(systemName: "checkmark.circle.fill")
                    .imageScale(.large)
                    .accessibility(label: Text("Mark as done"))
                Spacer()
            }
            HStack {
                ZStack {
                    Circle()
                        .frame(width: 5, height: 5)
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
                    self.dragOffset = .zero
                })
            )
        }
    }
}

struct TaskRow_Previews: PreviewProvider {
    static var previews: some View {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        return TaskRow(task: Task(context: context)).environment(\.managedObjectContext, context).environment(\.colorScheme, .light).previewLayout(.fixed(width: 375, height: 24))
    }
}
