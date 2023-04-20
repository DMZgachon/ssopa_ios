//
//  profileResponse.swift
//  ssopa
//
//  Created by Jiho Seo on 2023/04/03.
//

import Foundation


struct profileResponse: Codable {
    let status: Int
    let message: String
    let data: UserProfile
}
