//
//  UserRegistrationError.swift
//  RefactorTesting
//
//  Created by Orlando Medina Rodriguez on 12/10/24.
//


enum UserRegistrationError: Error {
    case emptyFields
    case invalidEmail
    case passwordTooShort
    case underageUser
}