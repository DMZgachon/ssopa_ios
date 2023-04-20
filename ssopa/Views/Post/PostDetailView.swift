//
//  PostDetailView.swift
//  ssopa
//
//  Created by Jiho Seo on 2023/03/10.
//

import SwiftUI

struct PostDetailView: View {
    @State var post: Post_Data.Post
    @StateObject var viewModel = postViewModel()
    var body: some View {
        
        Group {
                    if let postload = viewModel.post {
                        postDetailView(for: postload)
                            .refreshable {
                                print("refreshing")
                                do{
                                    try await viewModel.fetchPost(postId: post.id)
                                }catch{
                                    
                                }
                            }
                    } else {
                        postLoadingView(for: post)
                            
                    }
                }
                .task {
                    do{
                        try await viewModel.fetchPost(postId: post.id)
                    }catch{
                        
                    }
                }
        
        
    }
    
    
    private func postDetailView(for post: PostResponse.Post) -> some View {
            ScrollView {
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
                        Image(systemName: "envelope.open")
                            .foregroundColor(Color.ssopa_orange)
                        Text("\(post.view_cnt)")
                            .font(.caption2)
                            .fontWeight(.thin)
                            .padding(EdgeInsets.init(top: 0, leading:0, bottom: 0, trailing: 10))
                        if post.likeYn == false{
                            FavoriteButton(isSet: .constant(false),post: $post)
                        }else{
                            FavoriteButton(isSet: .constant(true),post: $post)
                        }
                        Text("\(post.like_cnt)")
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
    
    
    private func postLoadingView(for post: Post_Data.Post) -> some View {
            ScrollView {
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
                        Image(systemName: "envelope.open")
                            .foregroundColor(Color.ssopa_orange)
                        ProgressView()
                            .padding(EdgeInsets.init(top: 0, leading:0, bottom: 0, trailing: 10))
                        FavoriteButton(isSet: .constant(false),post: $post)
                        ProgressView()
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
   
    static var previews: some View {
        PostDetailView(post: Post_Data.Post.defaultPost)
        
        
            
            
    }
}
