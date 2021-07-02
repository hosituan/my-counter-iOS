//
//  LoginViewModel.swift
//  My Counter
//
//  Created by Hồ Sĩ Tuấn on 30/03/2021.
//

import Foundation
import FirebaseAuth

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
    
    @Published var confirmPassword: String = "" {
        didSet {
            checkSignUpValidation()
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
    
    //MARK: - Validation Password
    
    @Published var confirm: Bool = false
    private func checkSignUpValidation() {
        let passwordMin = Constants.PasswordMinCount
        self.confirm = (email.count >= passwordMin && password.count >= passwordMin && password == confirmPassword)
    }
    
//    func passwordMatch() -> Bool {
//        password == confirmPassword
//    }
//
//    func isPasswordValid() -> Bool {
//        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*\\d)(?=.*[a-z])(?=.*[A-Z]).{8,15}$")
//        return passwordTest.evaluate(with: password)
//    }
//    func isEmailValid() -> Bool {
//            // criteria in regex.  See http://regexlib.com
//            let emailTest = NSPredicate(format: "SELF MATCHES %@",
//                                        "^([a-zA-Z0-9_\\-\\.]+)@((\\[[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}\\.)|(([a-zA-Z0-9\\-]+\\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})(\\]?)$")
//            return emailTest.evaluate(with: email)
//    }
//
//    var isSignUpComplete: Bool {
//        if (!passwordMatch() ||
//        !isPasswordValid() ||
//        !isEmailValid() ) {
//            return false
//        }
//        return true
//    }
        
}
