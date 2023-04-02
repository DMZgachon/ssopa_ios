//
//  signUpResponse.swift
//  ssopa
//
//  Created by Jiho Seo on 2023/03/13.
//

import Foundation

struct signUpResponse: Codable {
    let status: Int
    let message: String
    let data: response
    
    struct response: Codable {
        let email: String
        let nickname: String
        let name: String
    }
}
