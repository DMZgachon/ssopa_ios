//
//  ChatRow.swift
//  ssopa
//
//  Created by Jiho Seo on 2023/03/31.
//

import SwiftUI

struct ChatRow: View {
    
    var chat: Chat
    
    var body: some View {
        VStack {
            HStack{
                VStack(alignment: .leading){
                    Text(chat.roomName)
                        .font(.headline)
                        .fontWeight(.semibold)
                    Text(chat.roomId)
                        .font(.caption2)
                        .fontWeight(.thin)

                    
                }
                .padding(EdgeInsets.init(top: 0, leading:10, bottom: 0, trailing: 0))
                Spacer()
                
                HStack{
                    Image(systemName: "heart.fill")
                        .foregroundColor(Color.ssopa_orange)
                        Text(Date.fromLocalDateTime(chat.created_Date)?.relativeTime() ?? "error")
                        .font(.caption2)
                        .fontWeight(.thin)
                        .padding(EdgeInsets.init(top: 0, leading:0, bottom: 0, trailing: 10))
                    
                }
                
            }
        }
    }
}

struct ChatRow_Previews: PreviewProvider {
    static var previews: some View {
        ChatRow(chat: Chat(roomId: "ss", roomName: "하이", founder_id: 54, created_Date: [2022,03,04,21,22,25,525255]))
    }
}


