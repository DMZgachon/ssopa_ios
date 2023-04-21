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
    
    @EnvironmentObject var chatMessageVm: chatMessageViewModel
    
    
    

    
    private func sendMessage() {
        
        chatMessageVm.sendMessage(content: newMessage)
        newMessage = ""
        
    }


    
    var chatRoom: Chat
    
    var body: some View {
        VStack {
            
            Text(chatMessageVm.isConnected ? "연결됨: \(chatRoom.roomId)":"연결 끊김: \(chatRoom.roomId)")
            
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
                
                ScrollViewReader { proxy in
                    List(chatMessageVm.Messages) { item in
                        HStack {
                            Text("\(item.message_id)")
                            Text("\(item.sender ?? "[로딩]"):")
                                    .bold()
                                    .foregroundColor(item.type.rawValue == "ENTER" ? .blue : .black)
                            Text("\(item.message ?? "[로딩]")")
                                      }
                        
                    }.onChange(of: chatMessageVm.isNewMsgExist) { value in
                        if value {
                            withAnimation {
                                proxy.scrollTo(chatMessageVm.Messages.last?.message_id, anchor: .bottom)
                            }
                            chatMessageVm.isNewMsgExist = false
                        }
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
            chatMessageVm.setroom(chatRoom.roomId)
            chatMessageVm.registerSocket()
            
        }.onDisappear{
            chatMessageVm.clearMsg()
            chatMessageVm.disconnect()
        }.navigationTitle(chatRoom.roomName)
        .navigationBarTitleDisplayMode(.inline)
        

        
        
    }
    
    
    
    
    
    struct ChatDetailView_Previews: PreviewProvider {
        static var previews: some View {
            ChatDetailView(chatRoom: Chat(roomId: "340f90f1-7d01-4e5e-ad4d-d8c2f84e8238", roomName: "20세 이하만", founder_id:45, created_Date: [2022,03,02,04,03,12,443445])).environmentObject(chatMessageViewModel())
        }
    }
}




