//
//  OpenChatView.swift
//  ssopa
//
//  Created by Jiho Seo on 2023/03/31.
//

import SwiftUI

struct OpenChatView: View {
    
    @EnvironmentObject var chatVm: chatViewModel

    func refreshVm(){
        chatVm.Chats=[]

    }
    
    var body: some View {
        
            if chatVm.Chats.isEmpty {
                ProgressView()
                // 앱을 처음 실행했을 때만 ProgressView를 보여줌
                    .task {
                        do {
                            try await chatVm.fetchChats()
                        } catch (let error) {
                            print("Unable to get data : \(error)")
                        }
                    }
            } else {
                    
                        List {
                            ForEach(chatVm.Chats) { item in
                                NavigationLink{
                                    ChatDetailView(chatRoom: item)
                                } label: {
                                    ChatRow(chat: item)
                                        .foregroundColor(Color.black)
                                }
                            }
                        }.refreshable {
                            print("refreshing")
                            refreshVm()
                            
                        }
                    
                }
        }
}


struct OpenChatView_Previews: PreviewProvider {
    static var previews: some View {
        let chatVm = chatViewModel()
        OpenChatView().environmentObject(chatVm)
            .environmentObject(chatMessageViewModel())
    }
}





