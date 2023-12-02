//
//  Item.swift
//  Poodle
//
//  Created by Luca Archidiacono on 30.11.2023.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
