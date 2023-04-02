//
//  chatVm.swift
//  ssopa
//
//  Created by Jiho Seo on 2023/03/31.
//

import Foundation

class chatViewModel: ObservableObject {
    
    
    @Published var Chats: [Chat] = []
    
    init() {}
    
    

    
    func fetchChats() async throws {
        let responseData: [Chat] = try await HTTPClient.shared.loadChats()
                
                // 기존 강좌 목록에 새로 가져온 강좌 목록을 추가
                DispatchQueue.main.async {
                    self.Chats = responseData
                }
    }
}
