//
//  PostDetailView.swift
//  ssopa
//
//  Created by Jiho Seo on 2023/03/10.
//

import SwiftUI

struct PostDetailView: View {
    var post: Post_Data.Post
    
   
    var body: some View {
        ScrollView{
            
            VStack(alignment: .leading) {
                
                HStack {
                    Text(post.writer)
                        
                    Spacer()
                    //Text(post.created_date)
                        
                }
                .font(.subheadline)
                .foregroundColor(.secondary)
                Divider()
                
                Text(post.content)
                    .font(.title2)
                    .padding(EdgeInsets.init(top: 0, leading:0, bottom: 10, trailing: 0))
                
                HStack{
                    Text(Date.fromLocalDateTime(post.modified_date)?.relativeTime() ?? "error")
                        .font(.caption2)
                        .fontWeight(.thin)
                        .padding(EdgeInsets.init(top: 0, leading:0, bottom: 0, trailing: 10))
                    
                    Spacer()
                    
                    Image(systemName: "heart.fill")
                        .foregroundColor(Color.ssopa_orange)
                    Text("\(post.view_cnt)")
                        .font(.caption2)
                        .fontWeight(.thin)
                        .padding(EdgeInsets.init(top: 0, leading:0, bottom: 0, trailing: 10))
                    
                }
                Divider()
                
                

            }
            .padding()
            
            
        }
        .navigationTitle(post.title)
        .navigationBarTitleDisplayMode(.inline)
    }
        
}


struct PostDetailView_Previews: PreviewProvider {
    static var getdata = ModelData().postdata
    static var previews: some View {
        PostDetailView(post: getdata.data[0])
            
            
    }
}
