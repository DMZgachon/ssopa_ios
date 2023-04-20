//
//  postVm.swift
//  ssopa
//
//  Created by Jiho Seo on 2023/03/25.
//

import Foundation

class postViewModel: ObservableObject {
    
    @Published var post: PostResponse.Post!
    
    @Published var Posts: [Post_Data.Post] = []
    
    @Published var HotPosts: [Post_Data.Post] = []
    
    init() {
     
    }
    
    
    func fetchPost(postId: Int) async throws{
        let delayInMilliseconds = 500 // Set the desired delay in milliseconds
        
        // Add delay before calling loadposts
        try await Task.sleep(nanoseconds: UInt64(delayInMilliseconds * 1_000_000))
        
        let responseData: PostResponse = try await HTTPClient.shared.loadPost(postId)
        
        // 기존 강좌 목록에 새로 가져온 강좌 목록을 추가
        DispatchQueue.main.async {
            self.post = responseData.data
        }
    }
    
    
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
    
    
    func fetchHotPosts() async throws {
            let delayInMilliseconds = 500 // Set the desired delay in milliseconds
            
            // Add delay before calling loadposts
            try await Task.sleep(nanoseconds: UInt64(delayInMilliseconds * 1_000_000))
            
            let responseData: Post_Data = try await HTTPClient.shared.loadHotposts()
            
            // 기존 강좌 목록에 새로 가져온 강좌 목록을 추가
            DispatchQueue.main.async {
                self.HotPosts = responseData.data
            }
        }
}
