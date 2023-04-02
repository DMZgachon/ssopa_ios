//
//  chatMessageVm.swift
//  ssopa
//
//  Created by Jiho Seo on 2023/03/31.
//

import Foundation


import Foundation

class chatMessageViewModel: ObservableObject {
    
    
    @Published var Messages: [ChatMessage] = []
    
    init() {}
    
    

    
    func fetchMessages(_ roomId: String, _ page: Int) async throws {
        let responseData: [ChatMessage] = try await HTTPClient.shared.loadMessages(roomId,page).data
                
                // 기존 강좌 목록에 새로 가져온 강좌 목록을 추가
                DispatchQueue.main.async {
                    self.Messages = responseData.reversed()
                }
    }
    
    
    func fetchMoreMessages(_ roomId: String, _ page: Int) async throws {
        
        
        let responseData: [ChatMessage] = try await HTTPClient.shared.loadMessages(roomId,page).data
                
                // 기존 강좌 목록에 새로 가져온 강좌 목록을 추가
                DispatchQueue.main.async {
                    self.Messages.insert(contentsOf: responseData, at: 0)
                }

    }
}
