//
//  FormatDate.swift
//  dotdos
//
//  Created by Gabriela Schirmer Mauricio on 23/06/19.
//  Copyright © 2019 Gabriela Schirmer Mauricio. All rights reserved.
//

import Foundation

extension UIViewController {
    func formatDate(date: Date, format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        let date = dateFormatter.string(from: date)
        return date
    }
}
