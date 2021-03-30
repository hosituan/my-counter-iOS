//
//  LoginViewModel.swift
//  My Counter
//
//  Created by Hồ Sĩ Tuấn on 30/03/2021.
//

import Foundation

class LoginViewModel: ObservableObject {
    @Published var email: String = ""
    {
        didSet {
            checkLoginValidation()
        }
    }
    @Published var password: String = "" {
        didSet {
            checkLoginValidation()
        }
    }
    @Published var validate: Bool = false
    
    private func checkLoginValidation() {
        let passwordMin = Constants.PasswordMinCount
        self.validate = (email.count >= passwordMin && password.count >= passwordMin)
    }
    
    func clearData() {
        self.email = ""
        self.password = ""
        self.validate = false
    }
}
