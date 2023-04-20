//
//  likeResponse.swift
//  ssopa
//
//  Created by Jiho Seo on 2023/04/03.
//

import Foundation


struct likeResponse:  Codable{
    let status: Int
    let message: String
    let data: likeResponse_data?
    
    struct likeResponse_data :Codable{
        var post: Post_Data.Post
        var userId: Int

    }
}
