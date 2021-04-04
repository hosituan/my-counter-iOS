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


class UserLogin: NSObject, ObservableObject, LoginButtonDelegate {
    
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
    let ggSigninButton = GoogleSignInButton()
    
    func logInGoogle() {
        ggSigninButton.onTapGesture {
            SocialLogin().attemptLoginGoogle()
        }
    }
    // Button
    struct GoogleSignInButton: UIViewRepresentable {
        func makeUIView(context: Context) -> GIDSignInButton {
            return GIDSignInButton()
        }
        
        func updateUIView(_ uiView: GIDSignInButton, context: Context) {
        }
    }

    // Sign-In flow UI of the provider
    struct SocialLogin: UIViewRepresentable {
        func makeUIView(context: UIViewRepresentableContext<SocialLogin>) -> UIView {
            return UIView()
        }

        func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<SocialLogin>) {
        }

        func attemptLoginGoogle() {
            GIDSignIn.sharedInstance()?.presentingViewController = UIApplication.shared.windows.last?.rootViewController
            GIDSignIn.sharedInstance()?.signIn()
        }
        
        func signOutGoogleAccount() {
            GIDSignIn.sharedInstance().signOut()
        }
    }
}



