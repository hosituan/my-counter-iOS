//
//  AppDelegate.swift
//  My Counter
//
//  Created by Hồ Sĩ Tuấn on 22/03/2021.
//

import UIKit
import CoreML
import Vision
import SwiftUI
import AVFoundation
import Firebase
import GoogleSignIn
import FirebaseRemoteConfig
import JGProgressHUD
import SocketIO

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    
    var window: UIWindow?
    var currenUser: User?
    var hud = JGProgressHUD(style: .light)
    var api: API?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor.black]
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.black]
        UIBarButtonItem.appearance().tintColor = .black
        UITableView.appearance().showsVerticalScrollIndicator = false
        
        UITableView.appearance().separatorStyle = .none
        UITableViewCell.appearance().backgroundColor = .clear
        UITableView.appearance().backgroundColor = .clear
        
        
        FirebaseApp.configure()
        setupRemoteConfig()
        
        // this will disable highlighting the cell when is selected
        UITableViewCell.appearance().selectionStyle = .none
        return true
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        //SocketManager.sharedInstance.closeConnection()
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        //SocketManager.sharedInstance.establishConnection()
    }
    
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    func application(_ application: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any])
    -> Bool {
        return GIDSignIn.sharedInstance().handle(url)
    }
    
    private func setupRemoteConfig() {
        let remoteConfig = RemoteConfig.remoteConfig()
        let settings = RemoteConfigSettings()
        settings.minimumFetchInterval = 0
        remoteConfig.configSettings = settings
        remoteConfig.fetch { (status, error) in
            if status == .success {
                print("Config fetched!")
                self.api = API()
                remoteConfig.activate { (success, erorr) in
                    if success {
                        apiUrl =  RemoteConfig.remoteConfig().configValue(forKey: "API_URL").stringValue ?? ""
                        print("API URL: " + apiUrl)
                        
                    }
                }
            } else {
                print("Config not fetched")
                print("Error: \(error?.localizedDescription ?? "No error available.")")
            }
        }
    }
}

extension AppDelegate {
    class func shared() -> AppDelegate
    {
        return UIApplication.shared.delegate as! AppDelegate
    }
    func requestCameraAccess(completionHandler: @escaping (Bool) -> Void) {
        // handler in .requestAccess is needed to process user's answer to our request
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized: // The user has previously granted access to the camera.
            completionHandler(true)
            
        case .notDetermined: // The user has not yet been asked for camera access.
            AVCaptureDevice.requestAccess(for: .video) { granted in
                if granted {
                    completionHandler(true)
                }
            }
            
        case .denied: // The user has previously denied access.
            camDenied()
            return
            
        case .restricted: // The user can't grant access due to restrictions.
            let alert = UIAlertController(title: "Restricted",
                                          message: "You've been restricted from using the camera on this device. Without camera access this feature won't work. Please contact the device owner so they can give you access.",
                                          preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(okAction)
            UIApplication.topViewController()?.present(alert, animated: true, completion: nil)
            completionHandler(false)
            return
        @unknown default:
            break
        }
    }
    
    func camDenied()
    {
        DispatchQueue.main.async
        {
            var alertText = "It looks like your privacy settings are preventing us from accessing your camera to do barcode scanning. You can fix this by doing the following:\n\n1. Close this app.\n\n2. Open the Settings app.\n\n3. Scroll to the bottom and select this app in the list.\n\n4. Turn the Camera on.\n\n5. Open this app and try again."
            
            var alertButton = "OK"
            var goAction = UIAlertAction(title: alertButton, style: .default, handler: nil)
            
            if UIApplication.shared.canOpenURL(URL(string: UIApplication.openSettingsURLString)!)
            {
                alertText = "It looks like your privacy settings are preventing us from accessing your camera to do barcode scanning. You can fix this by doing the following:\n\n1. Touch the Go button below to open the Settings app.\n\n2. Turn the Camera on.\n\n3. Open this app and try again."
                
                alertButton = "Go"
                
                goAction = UIAlertAction(title: alertButton, style: .default, handler: {(alert: UIAlertAction!) -> Void in
                    UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
                })
            }
            
            let alert = UIAlertController(title: "Error", message: alertText, preferredStyle: .alert)
            alert.addAction(goAction)
            UIApplication.topViewController()?.present(alert, animated: true, completion: nil)
        }
    }
}

//MARK: -- Alert
extension AppDelegate {
    func showAlertWithTwoButton(title: String? = nil, message: String?, action: @escaping ((UIAlertAction?) -> Void)) {
        
        let alert = UIAlertController(title: message, message: nil, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: action))
        self.window?.rootViewController?.present(alert, animated: true, completion: nil)
    }
    func showCommonAlert(message: String?) {
        let alert = UIAlertController(title: message, message: nil, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.window?.rootViewController?.present(alert, animated: true, completion: nil)
    }
    func showCommonAlertError(_ error: CountError?) {
        let alert = UIAlertController(title: "Error", message: error?.reason, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.window?.rootViewController?.present(alert, animated: true, completion: nil)
    }
    
    func showProgressHUD() {
        hud.show(in: (self.window?.rootViewController?.view)!)
    }
    func dismissProgressHUD() {
        hud.dismiss()
        hud = JGProgressHUD(style: .light)
    }
    
    func showSuccess() {
        hud.textLabel.text = "Done"
        hud.detailTextLabel.text = nil
        hud.indicatorView = JGProgressHUDSuccessIndicatorView()
        hud.show(in: (self.window?.rootViewController?.view)!)
        hud.dismiss(afterDelay: 2.0)
        hud = JGProgressHUD(style: .light)
    }
    
    func updateHUD(text: String, value: Int) {
        hud.textLabel.text = text
        hud.detailTextLabel.text = "\(value)s"
    }
}



//MARK: -- Top ViewController
extension UIApplication {
    class func topViewController(controller: UIViewController? = UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.rootViewController) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        return controller
    }
    
    
    func rootController() -> UIViewController? {
        let scenes = UIApplication.shared.connectedScenes.compactMap {
            $0 as? UIWindowScene
        }
        
        guard !scenes.isEmpty else { return nil }
        for scene in scenes {
            guard let root = scene.windows.first?.rootViewController else {
                continue
            }
            return root
        }
        return nil
    }
}



