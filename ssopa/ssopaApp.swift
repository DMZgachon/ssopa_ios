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
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(modelData)
                .environmentObject(postVm)
        }
    }
}
