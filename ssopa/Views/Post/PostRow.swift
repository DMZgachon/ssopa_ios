//
//  PostRow.swift
//  ssopa
//
//  Created by Jiho Seo on 2023/03/10.
//

import SwiftUI



struct PostRow: View {
    
    
    
    var post: Post_Data.Post
    
    var body: some View {
        
        
        VStack {
            HStack{
                VStack(alignment: .leading){
                    Text(post.title)
                        .font(.headline)
                        .fontWeight(.semibold)
                    Text(post.content)
                        .font(.caption2)
                        .fontWeight(.thin)
                    Text(post.writer)
                        .font(.caption2)
                        .fontWeight(.thin)
                    
                }
                .padding(EdgeInsets.init(top: 0, leading:10, bottom: 0, trailing: 0))
                Spacer()
                
                HStack{
                    Image(systemName: "heart.fill")
                        .foregroundColor(Color.ssopa_orange)
                    Text("\(post.view_cnt)")
                        .font(.caption2)
                        .fontWeight(.thin)
                        .padding(EdgeInsets.init(top: 0, leading:0, bottom: 0, trailing: 10))
                    Text(Date.fromLocalDateTime(post.modified_date)?.relativeTime() ?? "error")
                        .font(.caption2)
                        .fontWeight(.thin)
                        .padding(EdgeInsets.init(top: 0, leading:0, bottom: 0, trailing: 10))
                    
                }
                
            }
        }.swipeActions(allowsFullSwipe: false) {
            Button {
                print("Muting conversation")
            } label: {
                Label("Mute", systemImage: "bell.slash.fill")
            }
            .tint(.indigo)
            
            Button(role: .destructive) {
                print("Report")
            } label: {
            Label("신고하기", systemImage: "exclamationmark.shield.fill")
            }
        }
        
    }
        
       
    }


struct PostRow_Previews: PreviewProvider {

    static var getdata = ModelData().postdata
    static var previews: some View {

        Group {
            PostRow(post: getdata.data[0])
            PostRow(post: getdata.data[1])
                }
                .previewLayout(.fixed(width: 300, height: 70))
            
    }
    
    
}
