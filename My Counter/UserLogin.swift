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
import FirebaseAuth
import Firebase
import SwiftUI
import ProgressHUD
import GoogleSignIn


class UserLogin: NSObject, ObservableObject, LoginButtonDelegate, GIDSignInDelegate {
    
    
    
    @Published var isLogin = false
    {
        didSet {
            UserDefaults.standard.set(isLogin, forKey: "isLogin")
            self.objectWillChange.send()
        }
    }
    @Published var user: User?
    
    func logout() {
        fbLoginButton.sendActions(for: .touchUpInside)
    }
    
    func getUserInformation() {
        Auth.auth().addStateDidChangeListener { (auth, user) in
            if let user = user {
                self.user = user
                self.isLogin = true
            }
            ProgressHUD.dismiss()
        }
    }
    
    override init() {
        super.init()
        self.isLogin = UserDefaults.standard.bool(forKey: "isLogin")
        if isLogin {
            self.getUserInformation()
        }
        
        fbLoginButton.delegate = self
        
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self
    }
    
    
    //MARK:-- Facebook
    
    let fbLoginButton = FBLoginButton()
    
    func logInFacebook() {
        fbLoginButton.sendActions(for: .touchUpInside)
    }
    
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        self.isLogin = false
    }
    
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        if let error = error {
            print(error.localizedDescription)
            return
        }
        else {
            firebaseAuth()
        }
    }
    
    func firebaseAuth() {
        // `AccessToken` is generated after user logs in through Facebook SDK successfully
        ProgressHUD.show()
        if let facebookToken = AccessToken.current?.tokenString {
            let credential = FacebookAuthProvider.credential(withAccessToken: facebookToken)
            Auth.auth().signIn(with: credential) { (result, error) in
                if let error = error {
                    print("Firebase auth fails with error: \(error.localizedDescription)")
                    
                } else if let result = result {
                    print(result)
                    self.getUserInformation()
                }
            }
        }
    }
    //MARK:-- Google
    

    
    func logInGoogle() {
        GIDSignIn.sharedInstance()?.presentingViewController = UIApplication.shared.windows.first?.rootViewController
        GIDSignIn.sharedInstance()?.signIn()
    }
    
    func logOutGoogle() {
        GIDSignIn.sharedInstance()?.signOut()
        try! Auth.auth().signOut()
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if error != nil {
            print(error.localizedDescription)
            return
        }
        let credential = GoogleAuthProvider.credential(withIDToken: user.authentication.idToken, accessToken: user.authentication.accessToken)
        
        Auth.auth().signIn(with: credential) { (res, err) in
            if err !=   nil {
                print((err?.localizedDescription)!)
                return
            }
            
            //User Logged In Successfully
            
            //Sending Notification To UI
            NotificationCenter.default.post (name: NSNotification.Name("SIGNIN"),object:nil)
            
            print(res?.user.email)
        }
    }
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        <#code#>
    }
    
}



