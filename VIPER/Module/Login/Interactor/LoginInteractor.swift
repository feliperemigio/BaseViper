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
        let url = URL(string: "https://api.example.com/login")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let body: [String: String] = ["email": email, "password": password]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)

        URLSession.shared.dataTask(with: request) { [weak self] _, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    self?.delegate?.didLoginFailed(error: error.localizedDescription)
                    return
                }
                if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                    self?.delegate?.didLoginSuccess()
                } else {
                    self?.delegate?.didLoginFailed(error: "Invalid email or password.")
                }
            }
        }.resume()
    }
}
