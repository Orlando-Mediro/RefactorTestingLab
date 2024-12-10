//
//  UserManager.swift
//  RefactorTesting
//
//  Created by Orlando Medina Rodriguez on 12/10/24.
//


// UserManager.swift

import Foundation

class UserManager {
    private let validator: UserValidationProtocol
    private let userRepository: UserRepository
    private let emailService: EmailService
    
    init(
        validator: UserValidationProtocol,
        userRepository: UserRepository,
        emailService: EmailService
    ) {
        self.validator = validator
        self.userRepository = userRepository
        self.emailService = emailService
    }
    
    func registerUser(firstName: String, lastName: String, email: String, password: String, age: Int) throws {
        // Validate user input
        try validator.validateRegistration(firstName: firstName, lastName: lastName, email: email, password: password, age: age)
        
        // Create user
        let user = User(
            firstName: firstName,
            lastName: lastName,
            email: email,
            password: password, // Hypothetical secure hashing password.secureHash()
            age: age
        )
        
        // Save user
        try userRepository.saveUser(user: user)
        
        // Send welcome email
        try emailService.sendWelcomeEmail(email: email)
    }
    
    func authenticateUser(email: String, password: String) throws -> Bool {
        guard let user = userRepository.findUser(byEmail: email) else {
            throw AuthenticationError.userNotFound
        }
        
        return user.password == password // Secure comparison password.secureHash()
    }
}
