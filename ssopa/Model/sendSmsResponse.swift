//
//  sendSmsResponse.swift
//  ssopa
//
//  Created by Jiho Seo on 2023/03/12.
//

import Foundation

struct sendSmsResponse: Codable {
    let status: Int
    let message: String
    let data: smsResponseData
    
    struct smsResponseData: Codable {
        let success: Bool
    }
}
