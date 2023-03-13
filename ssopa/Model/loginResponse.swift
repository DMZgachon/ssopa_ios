//
//  loginResponse.swift
//  ssopa
//
//  Created by Jiho Seo on 2023/03/13.
//

import Foundation


import Foundation

struct loginResponse: Codable {
    let status: Int
    let message: String
    let data: response
    
    struct response: Codable {
        let grantType: String
        let accessToken :String
        let refreshToken: String
        let tokenExpiresIn: Int
        let refreshTokenExpiresIn: Int
    }
}
