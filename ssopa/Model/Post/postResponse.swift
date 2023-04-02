//
//  postResponse.swift
//  ssopa
//
//  Created by Jiho Seo on 2023/03/25.
//

import Foundation


struct PostResponse:  Codable{
    let status: Int
    let message: String
    let data: Post
    
    struct Post :Hashable, Codable,Identifiable{
        var id: Int
        var title: String
        var writer: String
        var content: String
        var category: String

    }
}
