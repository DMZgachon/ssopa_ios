//
//  postVm.swift
//  ssopa
//
//  Created by Jiho Seo on 2023/03/25.
//

import Foundation

class postViewModel: ObservableObject {
    
    
    @Published var Posts: [Post_Data.Post] = []
    
    init() {}
    
    
 
    
    
    func fetchMorePosts(_ page: Int, _ category: String) async throws {
        let responseData: Post_Data = try await HTTPClient.shared.loadposts(category, page)
                
                // 기존 강좌 목록에 새로 가져온 강좌 목록을 추가
                DispatchQueue.main.async {
                    self.Posts += responseData.data
                }
    }
    
    func fetchPosts(_ page: Int, _ category: String) async throws {
            let delayInMilliseconds = 500 // Set the desired delay in milliseconds
            
            // Add delay before calling loadposts
            try await Task.sleep(nanoseconds: UInt64(delayInMilliseconds * 1_000_000))
            
            let responseData: Post_Data = try await HTTPClient.shared.loadposts(category, 0)
            
            // 기존 강좌 목록에 새로 가져온 강좌 목록을 추가
            DispatchQueue.main.async {
                self.Posts = responseData.data
            }
        }
}
