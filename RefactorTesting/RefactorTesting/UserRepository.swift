//
//  UserRepository.swift
//  RefactorTesting
//
//  Created by Orlando Medina Rodriguez on 12/10/24.
//


protocol UserRepository {
    func saveUser(user: User) throws
    func findUser(byEmail email: String) -> User?
}
