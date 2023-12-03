//
//  KeychainController.swift
//
//
//  Created by Luca Archidiacono on 24.04.23.
//

import AuthenticationServices
import Foundation

/// This class is responsible for securely storing user sensitive information in the Keychain,
/// which is a more secure location compared to storing them in UserDefaults or a Database (e.g. CoreData).
public final class KeychainController {
	public init() {}

	/// Stores the secret given its location and service.
	/// If there is a duplica, then it just updates its entry.
	/// - Parameters:
	///    - secret: The sensitive information which needs to be stored inside the Keychain.
	///    - location: Information regarding to whom the sercret needs to be associated.
	///    - service:  The name of the service you wish to associate the `secret` & `location`.
	public func store(_ secret: String, for location: String, in service: String) throws {
		guard let secretData = secret.data(using: .utf8) else {
			throw KeychainError(message: "Error converting value to data.", type: .badData)
		}

		let query: [String: Any] = [
			kSecClass as String: kSecClassGenericPassword,
			kSecAttrAccount as String: location,
			kSecAttrService as String: service,
			kSecValueData as String: secretData,
		]

		let status = SecItemAdd(query as CFDictionary, nil)
		switch status {
		case errSecSuccess:
			break
		case errSecDuplicateItem:
			try update(secret, for: location, in: service)
		default:
			throw KeychainError(status: status, type: .servicesError)
		}
	}

	/// Retrieves the sensitive Information from the Keychain based on the specified `location` & `service`.
	/// Both must be correct for the `secret` to be found. Multiple `secret` & `location` can be saved for different
	/// services.
	/// - Parameters:
	///    - location: The `location` associated with the `secret`.
	///    - service: The `service` associated with the `secret` & `location`.
	public func getSecret(for location: String, in service: String) throws -> String {
		let query: [String: Any] = [
			kSecClass as String: kSecClassGenericPassword,
			kSecAttrAccount as String: location,
			kSecAttrService as String: service,
			kSecMatchLimit as String: kSecMatchLimitOne,
			kSecReturnAttributes as String: true,
			kSecReturnData as String: true,
		]

		var item: CFTypeRef?
		let status = SecItemCopyMatching(query as CFDictionary, &item)
		guard status != errSecItemNotFound else {
			throw KeychainError(status: status, type: .itemNotFound)
		}
		guard status == errSecSuccess else {
			throw KeychainError(status: status, type: .servicesError)
		}

		guard let existingItem = item as? [String: Any],
		      let valueData = existingItem[kSecValueData as String] as? Data,
		      let value = String(data: valueData, encoding: .utf8)
		else {
			throw KeychainError(status: status, type: .unableToConvertToString)
		}

		return value
	}

	/// Delete the sensitive information, based on the provided `location` & `service`.
	/// If the sensitive information is not found given the provided `location` & `service` it will silently complete.
	/// - Parameters:
	///    - location: The `location` associated with the `secret`.
	///    - service: The `service` associated with the `secret` & `location`.
	public func deleteSecret(for location: String, in service: String) throws {
		let query: [String: Any] = [
			kSecClass as String: kSecClassGenericPassword,
			kSecAttrAccount as String: location,
			kSecAttrService as String: service,
		]

		let status = SecItemDelete(query as CFDictionary)
		guard status == errSecSuccess || status == errSecItemNotFound else {
			throw KeychainError(status: status, type: .servicesError)
		}
	}

	private func update(_ secret: String, for location: String, in service: String) throws {
		guard let secretData = secret.data(using: .utf8) else {
			print("Error converting value to data.")
			return
		}
		let query: [String: Any] = [
			kSecClass as String: kSecClassGenericPassword,
			kSecAttrAccount as String: location,
			kSecAttrService as String: service,
		]

		let attributes: [String: Any] = [
			kSecValueData as String: secretData,
		]

		let status = SecItemUpdate(query as CFDictionary, attributes as CFDictionary)
		guard status != errSecItemNotFound else {
			throw KeychainError(
				message: "Matching Item Not Found",
				type: .itemNotFound
			)
		}
		guard status == errSecSuccess else {
			throw KeychainError(status: status, type: .servicesError)
		}
	}
}
