//
//  UserLogin.swift
//  My Counter
//
//  Created by Hồ Sĩ Tuấn on 30/03/2021.
//

import Foundation
import Combine
import FBSDKLoginKit
import SwiftyJSON
class UserLogin: ObservableObject {
    @Published var isLogin = false
    {
        didSet {
            UserDefaults.standard.set(isLogin, forKey: "isLogin")
        }
    }
    @Published var user: User = User()
    
    init() {
        self.isLogin = UserDefaults.standard.bool(forKey: "isLogin")
    }
    
    let loginManager = LoginManager()
    func facebookLogin(completionHandler: @escaping (Bool) -> Void) {
        loginManager.logIn(permissions: [.publicProfile, .email], viewController: nil) { loginResult in
            switch loginResult {
            case .failed(let error):
                print(error)
                completionHandler(false)
            case .cancelled:
                print("User cancelled login.")
                completionHandler(false)
            case .success(let grantedPermissions, let declinedPermissions, let accessToken):
                self.isLogin = true
                completionHandler(true)
                print("Logged in! \(grantedPermissions) \(declinedPermissions) \(String(describing: accessToken))")
                self.getUserInformation()
            }
        }
    }
    
    func getUserInformation() {
        let graphPath = "me/picture"
        let parameters = [
          "type": "large",
          "redirect": "false"
        ]
        GraphRequest(graphPath: "me", parameters: ["fields": "id, name, picture"]).start(completionHandler: { (connection, result, error) -> Void in
            if (error == nil) {
                let dict = result as! NSDictionary
                let id = dict["id"] as! String
                let name = dict["name"] as! String
                GraphRequest(graphPath: graphPath, parameters: parameters).start { (connection, result, error) in
                    if error == nil {
                        let json = JSON(result!)
                        let url = json["data"]["url"].stringValue
                        self.user = User(name: name, email: id, avatarUrl: url)
                    }
                }

            }
        })
    }
    func logout() {
        loginManager.logOut()
        self.isLogin = false
    }
}



