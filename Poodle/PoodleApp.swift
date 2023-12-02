//
//  PoodleApp.swift
//  Poodle
//
//  Created by Luca Archidiacono on 30.11.2023.
//

import SwiftUI
import SwiftData
import Martin

@main
struct PoodleApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(sharedModelContainer)
    }
}

actor XMPPClientManager {
	private var client = XMPPClient()
	private let authModule = AuthModule()
	private let streamFeaturesModule = StreamFeaturesModule()
	private let resourceBinderModule = ResourceBinderModule()
	private let sessionEstabilshmentModule = SessionEstablishmentModule()
	private let messageModule = MessageModule(chatManager: <#T##ChatManager#>)

	init() {
		client.modulesManager
			.register(streamFeaturesModule)
			.register(authModule)
			.register(resourceBinderModule)
			.register(sessionEstabilshmentModule)
	}


}

extension XmppModulesManager {
	@discardableResult
	func register(_ module: XmppModule) -> XmppModulesManager {
		let _: XmppModule = self.register(module)
		return self
	}
}
