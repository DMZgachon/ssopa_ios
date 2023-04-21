//
//  chatMessageVm.swift
//  ssopa
//
//  Created by Jiho Seo on 2023/03/31.
//

import Foundation
import StompClientLib

class chatMessageViewModel: ObservableObject, StompClientLibDelegate {
    
    
    @Published var Messages: [ChatMessage] = []
    var socketClient = StompClientLib()
    var url = NSURL()
    var keychain = KeyChain()
    @Published var isConnected: Bool = false
    @Published var isNewMsgExist: Bool = false
    var topic = ""
    var roomId = ""
    func setroom(_ room: String){
        self.topic = "/topic/chat/room/\(room)"
        self.roomId = room
    }
    
    init() {
        
    }
    
    func clearMsg(){
        Messages = []
    }
    
    func registerSocket(){
        
        let completedWSURL = "wss://ssopa02.com/api/ws/chat/websocket"
        url = NSURL(string: completedWSURL)!
        socketClient.openSocketWithURLRequest(
            request: NSURLRequest(url: url as URL),
                    delegate: self,
                    connectionHeaders: [ "Authorization" : "Bearer \(keychain.getItem(key: "accessToken") ?? "null")"]
                )
    }
    
    func stompClientDidConnect(client: StompClientLib!) {
        isConnected = true
        print("wss connected: \(self.topic)")
        socketClient.subscribe(destination: topic)
        let header = [StompCommands.commandHeaderContentType:"application/json;charset=UTF-8", "Authorization" : "Bearer \(keychain.getItem(key: "accessToken") ?? "null")"]
        socketClient.sendMessage(message: "{\"type\":\"ENTER\",\"roomId\":\"\(roomId)\",\"sender\":\"1\"}", toDestination: "/app/chat/message", withHeaders: header, withReceipt: nil)
    }
    
    func stompClientDidDisconnect(client: StompClientLib!) {
        isConnected = false
        print("Socket is Disconnected")
    }
    
    func disconnect(){
        socketClient.disconnect()
    }
   
    
    func sendMessage(content : String) {
        do {
//            let theJSONData = try JSONSerialization.data(withJSONObject: dict, options: JSONSerialization.WritingOptions())
//            let theJSONText = String(data: theJSONData, encoding: String.Encoding.utf8)
            //print(theJSONText!)
            let header = [StompCommands.commandHeaderContentType:"application/json;charset=UTF-8", "Authorization" : "Bearer \(keychain.getItem(key: "accessToken") ?? "null")"]
            socketClient.sendMessage(message: "{\"type\":\"TALK\",\"roomId\":\"\(roomId)\",\"sender\":\"1\",\"message\":\"\(content)\"}", toDestination: "/app/chat/message", withHeaders: header, withReceipt: nil)
        } catch {
            print("error serializing JSON: \(error)")
        }
    }
    

    
    func stompClient(client: StompClientLib!, didReceiveMessageWithJSONBody jsonBody: AnyObject?, akaStringBody stringBody: String?, withHeader header: [String : String]?, withDestination destination: String) {
        print("DESTINATION : \(destination)")
        print("JSON BODY : \(String(describing: jsonBody))")
        print("STRING BODY : \(stringBody ?? "nil")")
        
        let jsonData = stringBody!.data(using: .utf8)!
        let decoder = JSONDecoder()
        var chatMessage = try! decoder.decode(ChatMessage.self, from: jsonData)
        
        let lastMessageId = self.Messages.last?.id ?? -1
        
        chatMessage.message_id = lastMessageId + 1
        
        self.Messages.append(chatMessage)
        
        isNewMsgExist = true
        

        
    }
    
    func serverDidSendReceipt(client: StompClientLib!, withReceiptId receiptId: String) {
        print("Receipt : \(receiptId)")
    }
    
    func serverDidSendError(client: StompClientLib!, withErrorMessage description: String, detailedErrorMessage message: String?) {
        print("Error : \(String(describing: message))")
    }
    
    func serverDidSendPing() {
        print("Server Ping")
    }
    
    
    func stompClientJSONBody(client: StompClientLib!, didReceiveMessageWithJSONBody jsonBody: String?, withHeader header: [String : String]?, withDestination destination: String) {
        print("DESTINATION : \(destination)")
        print("String JSON BODY : \(String(describing: jsonBody))")
    }

    
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


