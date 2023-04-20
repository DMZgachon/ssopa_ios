//
//  SettingView.swift
//  ssopa
//
//  Created by Jiho Seo on 2023/04/05.
//

import SwiftUI
import UIKit

struct SettingView: View {
    
    static let shared: SettingView = SettingView()
    // Add a new @State property to track whether the full-size image should be displayed
    @State private var showFullScreenProfileImage = false
    
    
    func switchToForm() {
        

        let newView = LoginMain()
        let rootView = UIHostingController(rootView: newView)
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                  let window = windowScene.windows.first
            else {
                return
            }
            window.rootViewController = rootView
            window.makeKeyAndVisible()
        }
    
    
    func getProfile() -> UserProfile{
        if let userData = UserDefaults.standard.data(forKey: "userProfile") {
            do {
                let decoder = JSONDecoder()
                let user = try decoder.decode(UserProfile.self, from: userData)
                return user
            } catch {
                print("Error decoding user: \(error.localizedDescription)")
                return UserProfile.defaultProfile
            }
        } else {
            print("No user data found in UserDefaults")
            return UserProfile.defaultProfile
        }
    }
    
    var body: some View {
        
            List {
                NavigationLink {
                    profileDetail(profile: getProfile())
                } label: {
                    ProfileSummary(profile: getProfile(), showFullScreenProfileImage: $showFullScreenProfileImage)
                }
                Button("로그아웃") {
                    HTTPClient.shared.logout(){result in
                        if result{
                            switchToForm()
                        }
                    }
                }
                


            }.overlay(
                FullSizeImageView(image_url: getProfile().profileImage!, showFullScreenProfileImage: $showFullScreenProfileImage)
            )
    }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView()
    }
}
