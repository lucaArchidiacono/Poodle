//
//  XmppModulesManager+.swift
//  Poodle
//
//  Created by Luca Archidiacono on 02.12.2023.
//

import Foundation
import Martin

extension XmppModulesManager {
    @discardableResult
    func register(_ module: XmppModule) -> XmppModulesManager {
        let _: XmppModule = self.register(module)
        return self
    }
}
