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
    
    var returnDay: String {
        let format = DateFormatter()
        format.dateFormat = "dd"
        let formattedDate = format.string(from: Date())
        return formattedDate
    }

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
            TaskList()
                .tabItem({
                    Image(systemName: "\(returnDay).square.fill")
                        .font(.system(size: 24))
                })
                .tag(0)
            
//            Text("The Second Tab")
//                .tabItem({
//                    Image(systemName: "plus.circle.fill")
//                        .font(.system(size: 24))
//                })
//                .tag(1)
//
//            Text("The Last Tab")
//                .tabItem({
//                    Image(systemName: "calendar")
//                        .font(.system(size: 24))
//                })
//                .tag(2)

        }
        .accentColor(.primary)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
