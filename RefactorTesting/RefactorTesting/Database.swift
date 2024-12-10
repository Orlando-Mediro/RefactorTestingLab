//
//  Database.swift
//  RefactorTesting
//
//  Created by Orlando Medina Rodriguez on 12/10/24.
//


// Database.swift

import Foundation

class Database {
    private static var users: [User] = []

    static func saveUser(user: User) throws {
        users.append(user)
    }

    static func getUserByEmail(email: String) -> User? {
        return users.first { $0.email == email }
    }
}
