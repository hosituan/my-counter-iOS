//
//  SceneDelegate.swift
//  My Counter
//
//  Created by Hồ Sĩ Tuấn on 22/03/2021.
//

import UIKit
import SwiftUI
import KYDrawerController
import PartialSheet
import FBSDKCoreKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    let sheetManager: PartialSheetManager = PartialSheetManager()
    let drawerController = KYDrawerController(drawerDirection: .right, drawerWidth: 300)
    
    let userLogin = UserLogin()
    let menuHandler = MenuHandler()
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        // init facebook SDK
        ApplicationDelegate.initializeSDK(nil)
        Settings.isAutoLogAppEventsEnabled = true
        Settings.isAdvertiserIDCollectionEnabled = true
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        
        // Create the SwiftUI view that provides the window contents.
        
        let contentView = ContentView(showMenuAction: {
            self.drawerController.setDrawerState(.opened, animated: true)
        })
        .environmentObject(userLogin)
        .environmentObject(menuHandler)
        drawerController.mainViewController = UIHostingController(rootView: contentView)
        
        let loginView = LoginView(dismissAction: { self.drawerController.dismiss( animated: true, completion: nil)}).environmentObject(userLogin)
        let loginVc = UIHostingController(rootView: loginView)
        loginVc.modalPresentationStyle = .fullScreen
        
        drawerController.drawerViewController = UIHostingController(rootView: MenuView(showLoginAction: { self.drawerController.present(loginVc, animated: true, completion: nil) }).environmentObject(userLogin)
                                                                        .environmentObject(menuHandler))
        
        // Use a UIHostingController as window root view controller.
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            let vc = drawerController
            vc.view.frame = window.bounds
            window.rootViewController = vc
            self.window = window
            (UIApplication.shared.delegate as? AppDelegate)?.self.window = window
            window.makeKeyAndVisible()
        }
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }
    
    
}

