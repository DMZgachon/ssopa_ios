//
//  ChatDetailView.swift
//  ssopa
//
//  Created by Jiho Seo on 2023/03/31.
//

import SwiftUI




struct ChatDetailView: View {
    
    @State private var newMessage = ""
    @State private var page: Int = 0
    @State private var loadedIdx: [Int: Bool] = [:]
    private let keychain = KeyChain()
    
    var chatMessageVm: chatMessageViewModel
    
    
    
    
    
    init(chatRoom: Chat) {
        self.chatRoom = chatRoom
        self.chatMessageVm = chatMessageViewModel()
    }
    
    private func sendMessage() {
        
        newMessage = ""
    }


    
    var chatRoom: Chat
    
    var body: some View {
        VStack {
            if chatMessageVm.Messages.isEmpty {
                ProgressView()
                    .task {
                        do {
                            try await chatMessageVm.fetchMessages(chatRoom.roomId, 0)
                        } catch(let error) {
                            print("Unable to get data : \(error)")
                        }
                    }
            } else {
                List(chatMessageVm.Messages) { item in
                    HStack {
                        Text("\(item.sender ?? "[로딩]"):")
                                .bold()
                                .foregroundColor(item.type.rawValue == "ENTER" ? .blue : .black)
                        Text("\(item.message ?? "[로딩]")")
                                  }
                    
                }
            }
        
            
         
            
            HStack {
                TextField("Type your message", text: $newMessage)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                Button("Send") {
                    sendMessage()
                }
                .disabled(newMessage.isEmpty)
            }
            .padding()
           
            
            
        }.onAppear{
            
            
        }.onDisappear{
          
        }.navigationTitle(chatRoom.roomName)
        .navigationBarTitleDisplayMode(.inline)
        

        
        
    }
    
    
    
    
    
    struct ChatDetailView_Previews: PreviewProvider {
        static var previews: some View {
            ChatDetailView(chatRoom: Chat(roomId: "340f90f1-7d01-4e5e-ad4d-d8c2f84e8238", roomName: "20세 이하만", founder_id:45, created_Date: [2022,03,02,04,03,12,443445]))
        }
    }
}




