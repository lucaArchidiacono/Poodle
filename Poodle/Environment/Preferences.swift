//
//  Preferences.swift
//  Poodle
//
//  Created by Luca Archidiacono on 02.12.2023.
//

import Foundation
import SwiftUI

@MainActor
final class Preferences: ObservableObject {
    static let sharedDefault = UserDefaults(suiteName: "lucaa.ch.Poodle")
    static let shared = Preferences()
    
    @AppStorage("account") public var hapticTabSelectionEnabled = true
    
    private init() {}
}
