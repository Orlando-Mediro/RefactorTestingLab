//
//  UserValidationProtocol.swift
//  RefactorTesting
//
//  Created by Orlando Medina Rodriguez on 12/10/24.
//


protocol UserValidationProtocol {
    func validateRegistration(firstName: String, lastName: String, email: String, password: String, age: Int) throws
}