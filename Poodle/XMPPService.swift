//
//  XMPPService.swift
//  Poodle
//
//  Created by Luca Archidiacono on 02.12.2023.
//

import Foundation
import Martin
import Combine
import OSLog

class XMPPService: ObservableObject {
    private var client = XMPPClient()
    private let authModule = AuthModule()
    private let streamFeaturesModule = StreamFeaturesModule()
    private let resourceBinderModule = ResourceBinderModule()
    private let sessionEstabilshmentModule = SessionEstablishmentModule()
    private let messageModule = MessageModule(chatManager: ChatManagerBase(store: DefaultChatStore()))

    static let shared: XMPPService = XMPPService()
    
    private let logger = Logger()
    
    @Published var state: XMPPClient.State = .disconnected(.none)
    
    private init() {
        observe()
        
        client.modulesManager
            .register(streamFeaturesModule)
            .register(authModule)
            .register(resourceBinderModule)
            .register(sessionEstabilshmentModule)
            .register(messageModule)
        
        
    }
    
    private func observe() {
        client.context.$state
            .map { [weak self] state in
                guard let self else { return state }
                switch state {
                case .connecting:
                    logger.info("Manager is connecting.")
                case .connected(let resumed):
                    logger.info("\(resumed ? "Manager resumed connection." : "Manager connected.")")
                case .disconnecting:
                    logger.info("Manager is disconnecting.")
                case .disconnected(let reason):
                    logger.info("Manager disconnected reason: \(reason).")
                }
               return state
            }
            .assign(to: &$state)
    }
    
    /// Called when session is established
    private func sessionEstablished() {
//        print("Now we are connected to server and session is ready..")
//        
//        let recipient = BareJID("larchidiacono@futurelab.ch")
//        guard let chat = messageModule.chatManager.createChat(for: client.context, with: recipient) else { return }
//        
//        print("Sending message to", recipient, "..")
//        
//        let message = Message()
//        message.body = "I'm now online.."
//        chat.send(message: <#T##Message#>)
//        chat.send(message: message) { [weak self] result in
//            guard let self else { return }
//        }
//
//        print("Waiting 1 sec to ensure message is sent");
//        sleep(1);
//        print("Disconnecting from server..");
//        client.disconnect();
    }
}
