//
//  Logger+.swift
//  Poodle
//
//  Created by Luca Archidiacono on 02.12.2023.
//

import Foundation
import OSLog

extension Logger {
    private static var subsystem = Bundle.main.bundleIdentifier!
    
    init(category: String) {
        self.init(subsystem: Self.subsystem, category: category)
    }
    
    init() {
        self.init(subsystem: Self.subsystem, category: #file)
    }
}
