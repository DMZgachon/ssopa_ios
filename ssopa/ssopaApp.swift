//
//  ssopaApp.swift
//  ssopa
//
//  Created by Jiho Seo on 2023/03/09.
//

import SwiftUI

@main
struct ssopaApp: App {
    @StateObject private var modelData = ModelData()
    @StateObject private var postVm = postViewModel()
    @StateObject private var chatVm = chatViewModel()
    @StateObject private var chatMessageVm = chatMessageViewModel()
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(modelData)
                .environmentObject(postVm)
                .environmentObject(chatVm)
        }
    }
}
