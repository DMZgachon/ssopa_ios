//
//  hotBoardView.swift
//  ssopa
//
//  Created by Jiho Seo on 2023/04/02.
//


import SwiftUI

struct hotBoardView: View {
    
    @EnvironmentObject var postVm: postViewModel
    
    
    func refreshVm(){
        postVm.HotPosts = []
    }
    
    var body: some View {
        if postVm.HotPosts.isEmpty {
            ProgressView()
            // 앱을 처음 실행했을 때만 ProgressView를 보여줌
                .task {
                    do {
                        try await postVm.fetchHotPosts()
                    } catch (let error) {
                        print("Unable to get data : \(error)")
                        
                    }
                }
        } else {
                
                    List {
                        ForEach(postVm.HotPosts) { item in
                            NavigationLink{
                                PostDetailView(post: item)
                            } label: {
                                PostRow(post: item)
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

struct hotBoardView_Previews: PreviewProvider {

    static var previews: some View {
        let postVm = postViewModel()
        hotBoardView().environmentObject(postVm)
    }
}
