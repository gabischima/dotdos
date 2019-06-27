//
//  Extensions+Date.swift
//  dotdos
//
//  Created by Gabriela Schirmer | MundiPagg on 27/06/19.
//  Copyright © 2019 Gabriela Schirmer Mauricio. All rights reserved.
//

import Foundation

extension Date {
    
    var nextDay: Date! {
        return Calendar.current.date(byAdding: .day, value: 1, to: self)
    }
    
    var previousDay: Date! {
        return Calendar.current.date(byAdding: .day, value: -1, to: self)
    }
}
