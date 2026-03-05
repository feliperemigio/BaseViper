//
//  LoginInteractor.swift
//  VIPER
//
//  Created by Felipe Remigio on 22/05/20.
//  Copyright © 2020 Remigio All rights reserved.
//
import Foundation

protocol LoginInteractorProtocol: BaseInteractorProtocol {
    func login(email: String, password: String)
}

final class LoginInteractor: BaseInteractor<LoginInteractorDelegate> {
}

protocol LoginInteractorDelegate: BaseInteractorDelegate {
    func loginStarted()
    func didLoginSuccess()
    func didLoginFailed(error: String)
}

extension LoginInteractor: LoginInteractorProtocol {
    func login(email: String, password: String) {
        self.delegate?.loginStarted()
        DispatchQueue.global().asyncAfter(deadline: .now() + 2) {
            DispatchQueue.main.async {
                if email == "user@example.com" && password == "password123" {
                    self.delegate?.didLoginSuccess()
                } else {
                    self.delegate?.didLoginFailed(error: "Invalid email or password.")
                }
            }
        }
    }
}
