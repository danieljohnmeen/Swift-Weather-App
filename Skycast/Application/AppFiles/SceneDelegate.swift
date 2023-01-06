//
//  SceneDelegate.swift
//  Skycast
//
//  Created by Малиль Дугулюбгов on 16.12.2022.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    private let appFactory: AppFactory = DI()
    private var appCoordinator: Coordinator?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {

        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let (window, coordinator) = appFactory.makeKeyWindowAndCoordinator(with: windowScene)
        
        appCoordinator = coordinator
        appCoordinator?.start(with: nil)
        
        self.window = window
        window.overrideUserInterfaceStyle = .dark
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
        updateDataAfterBackground()
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        UserDefaults.standard.saveBackgroundModeEnteringTime(Date())
    }
    
    private func updateDataAfterBackground() {
        guard
            let backgroundEnterTime = UserDefaults.standard.getBackgroundModeEnteringTime(),
            let minutes = Calendar.current.minutes(from: backgroundEnterTime, to: Date()),
            minutes >= 5
        else { return }
        NotificationCenter.default.post(name: .updateAfterBackground, object: nil)
    }


}

