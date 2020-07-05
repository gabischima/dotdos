//
//  ContentView.swift
//  dotdos
//
//  Created by Gabriela Schirmer Mauricio on 28/06/20.
//  Copyright © 2020 Gabriela Schirmer Mauricio. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State private var selection: Int = 0

    init() {
        // set table view style
        UITableView.appearance().separatorStyle = .none
        UITableViewCell.appearance().selectionStyle = .none

        // set navigation bar style
        let navigationAppearance = UINavigationBarAppearance()
        navigationAppearance.shadowColor = .clear
        navigationAppearance.backgroundColor = UIColor.systemBackground
        navigationAppearance.titleTextAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16, weight: .black)]
        UINavigationBar.appearance().standardAppearance = navigationAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = navigationAppearance

        // set tab bar style
        let tabbarAppearance = UITabBarAppearance()
        tabbarAppearance.configureWithOpaqueBackground()
        tabbarAppearance.shadowColor = .clear
        UITabBar.appearance().standardAppearance = tabbarAppearance
    }
    
    var body: some View {
        TabView(selection:$selection) {
            TaskList(NSPredicate(format: "dueDate == %@", DateTransform.getStringFromDate(Date()) as CVarArg))
                .tabItem({
                    Image(systemName: "\(DateTransform.dayString).square.fill")
                        .font(.system(size: 24))
                })
                .tag(0)
            
//            Text("The Second Tab")
//                .tabItem({
//                    Image(systemName: "plus.circle.fill")
//                        .font(.system(size: 24))
//                })
//                .tag(1)

            TaskList(nil)
                .tabItem({
                    Image(systemName: "calendar")
                        .font(.system(size: 24))
                })
                .tag(2)

        }
        .accentColor(.primary)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
