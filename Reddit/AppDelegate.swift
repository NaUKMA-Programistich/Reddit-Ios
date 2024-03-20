//
//  AppDelegate.swift
//  Reddit
//
//  Created by Programistich on 22.02.2023.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    private let viewModel = PostListViewModel.share
    private let saveDelegate = PostListSaver.share


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
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

    func applicationWillTerminate(_ application: UIApplication) {
        guard case let .succesfull(posts: posts, _, _, _) = viewModel.state else { return }
        saveDelegate.saveOfflinePosts(posts: posts.filter{ $0.isSaved })
    }

}

