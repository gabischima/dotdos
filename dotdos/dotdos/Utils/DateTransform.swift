//
//  DateTransform.swift
//  dotdos
//
//  Created by Gabriela Schirmer Mauricio on 05/07/20.
//  Copyright © 2020 Gabriela Schirmer Mauricio. All rights reserved.
//

import Foundation

struct DateTransform {
    static var dayString: String {
        let format = DateFormatter()
        format.dateFormat = "dd"
        let formattedDate = format.string(from: Date())
        return formattedDate
    }

    static func getStringFromDate(_ date: Date) -> String {
        let format = DateFormatter()
        format.dateFormat = "YYYY-MM-dd"
        let formattedDate = format.string(from: date)
        return formattedDate
    }
}
