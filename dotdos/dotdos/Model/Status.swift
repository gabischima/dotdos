//
//  Status.swift
//  dotdos
//
//  Created by Gabriela Schirmer Mauricio on 05/07/20.
//  Copyright © 2020 Gabriela Schirmer Mauricio. All rights reserved.
//

import Foundation
import Combine

enum Status: String, CaseIterable, Codable, Hashable {
    case toDo = "To do"
    case doing = "Doing"
    case done = "Done"
}
