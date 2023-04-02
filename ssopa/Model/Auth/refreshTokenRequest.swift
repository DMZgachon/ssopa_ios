//
//  refreshTokenRequest.swift
//  ssopa
//
//  Created by Jiho Seo on 2023/03/30.
//


import Foundation

struct refreshTokenRequest: Codable {
    let accessToken: String
    let refreshToken: String
  
}
