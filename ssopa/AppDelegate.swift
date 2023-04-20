//
//  AppDelegate.swift
//  ssopa
//
//  Created by Jiho Seo on 2023/04/17.
//

import Foundation
import UIKit
import SwiftUI


class AppDelegate: NSObject, UIApplicationDelegate {
    @State var deviceToken: String = ""
    //애플리케이션이 실행된 직후 사용자의 화면에 보여지기 직전에 호출
    func application(_ application: UIApplication,
               didFinishLaunchingWithOptions launchOptions:
                     [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
       // Override point for customization after application launch.you’re
       askNotification()
       UIApplication.shared.registerForRemoteNotifications()
       return true
    }
    
    let center = UNUserNotificationCenter.current()
    
    func askNotification(){
    
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            
            if let error = error {
                // Handle the error here.
            }
            
            // Enable or disable features based on the authorization.
        }
    }
    
    //원격 푸시 알림 토큰을 요청한 후
    func application(_ application: UIApplication,
                didRegisterForRemoteNotificationsWithDeviceToken
                    deviceToken: Data) {
        
        let tokenComponents = deviceToken.map { data in String(format: "%02.2hhx", data) }
        let deviceTokenString = tokenComponents.joined()
        print("토큰 \(deviceTokenString)")
        self.deviceToken = deviceTokenString
        HTTPClient.shared.forwardTokenToServer(deviceTokenString)
    }
    
    
    
    
    //원격 푸시 알림 토큰 요청이 실패 했을때
    func application(_ application: UIApplication,
                didFailToRegisterForRemoteNotificationsWithError
                    error: Error) {
       // Try again later.
       print("Remote notification support is unavailable due to error: \(error.localizedDescription)")
    }
    
    //애플리케이션이 백그라운드 상태로 전환된 직후 호출
    func applicationDidEnterBackground(_ application: UIApplication){
        print("Status: Background")
    }

    //애플리케이션이 Active 상태가 되기 직전, 화면에 보여지기 직전에 호출
    func applicationWillEnterForeground(_ application: UIApplication){
        print("Status: Before Activated")
    }

    //애플리케이션이 Active 상태로 전환된 직후 호출
    func applicationDidBecomeActive(_ application: UIApplication){
        print("Status: Active!")
    }

    //애플리케이션이 종료되기 직전에 호출
    func applicationWillTerminate(_ application: UIApplication){
        print("Status: Terminated")
    }


}
