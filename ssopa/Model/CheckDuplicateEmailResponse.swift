//
//  CheckDuplicateEmailResponse.swift
//  ssopa
//
//  Created by Jiho Seo on 2023/03/10.
//

import Foundation


struct CheckDuplicateEmailResponse: Codable {
    let status: Int
    let message: String
    let data: ResponseData
    
    struct ResponseData: Codable {
        let duplicated: Bool
    }
}
