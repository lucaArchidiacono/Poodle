//
//  KeychainError.swift
//
//
//  Created by Luca Archidiacono on 24.04.23.
//

import Foundation

public struct KeychainError: Error, CustomStringConvertible {
	public var description: String
	public var type: KeychainErrorType

	public enum KeychainErrorType {
		case badData
		case servicesError
		case itemNotFound
		case unableToConvertToString
	}

	public init(status: OSStatus, type: KeychainErrorType) {
		self.type = type
		if let errorMessage = SecCopyErrorMessageString(status, nil) {
			self.description = String(errorMessage)
		} else {
			self.description = "Status Code: \(status)"
		}
	}

	public init(message: String, type: KeychainErrorType) {
		self.description = message
		self.type = type
	}
}
