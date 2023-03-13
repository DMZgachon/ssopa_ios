//
//  UserProfile.swift
//  ssopa
//
//  Created by Jiho Seo on 2023/03/10.
//

import Foundation

struct UserProfile {
    var nickname: String
    var school : String
    var Role = Role.user


    static let `default` = UserProfile(nickname: "행복한 물고기",school: "남악고등학교")

    enum Role: String, CaseIterable, Identifiable {
        case user = "🌷"
        case admin = "🌞"

        var id: String { rawValue }
    }
}
