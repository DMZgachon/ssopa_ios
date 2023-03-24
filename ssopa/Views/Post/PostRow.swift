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
            Divider()
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
                    
                }
                
            }
        }
        
        
    }
        
       
    }


struct PostRow_Previews: PreviewProvider {
//    static var Post1: Post = Post(id: 1, title: "페이커 vs bts 멤버", writer: "붕붕이", content: "군대가면 누가 더 좋은 취급 받을까", view_cnt: 1, noticeYn: false, modified_date: "20220304", created_date: "20220304", deleteYn: false)
    static var getdata = ModelData().postdata
    static var previews: some View {

        Group {
            PostRow(post: getdata.data[0])
            PostRow(post: getdata.data[1])
                }
                .previewLayout(.fixed(width: 300, height: 70))
            
    }
    
    
}
