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
    
    static func getDateLabel(_ string: String) -> String {
        let format = DateFormatter()
        format.dateFormat = "YYYY-MM-dd"
        guard let dateObj = format.date(from: string) else { return "" }
        format.dateFormat = "dd/MM/YYYY"
        return format.string(from: dateObj)

    }
    
    static func getDateFromString(_ string: String) -> Date {
        let format = DateFormatter()
        format.dateFormat = "YYYY-MM-dd"
        return format.date(from: string)!
    }

    static func getStringFromDate(_ date: Date) -> String {
        let format = DateFormatter()
        format.dateFormat = "YYYY-MM-dd"
        let formattedDate = format.string(from: date)
        return formattedDate
    }
}
