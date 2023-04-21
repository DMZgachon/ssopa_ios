//
//  freeBoardView.swift
//  ssopa
//
//  Created by Jiho Seo on 2023/03/25.
//

import SwiftUI

struct freeBoardView: View {
    
    @EnvironmentObject var postVm: postViewModel
    @State private var page: Int = 0
    @State private var loadedIdx : [Int:Bool] = [:]
    
    func refreshVm(){
        postVm.Posts = []
        page = 0
        loadedIdx = [:]
    }
    
    
    
    var body: some View {
        if postVm.Posts.isEmpty {
            ProgressView()
            // 앱을 처음 실행했을 때만 ProgressView를 보여줌
                .task {
                    do {
                        try await postVm.fetchPosts(0, "FREE")
                    } catch (let error) {
                        print("Unable to get data : \(error)")
                    }
                }
        } else {
                
                    List {
                        ForEach(postVm.Posts) { item in
                            NavigationLink{
                                PostDetailView(post: item)
                            } label: {
                                PostRow(post: item)
                                    .foregroundColor(Color.black)
                            }
                                .onAppear {
                                    guard let index = postVm.Posts.firstIndex(where: { $0.id == item.id }) else { return }
                                    
                                    print("index: \(index)")
                                    if index % 20 == 0 && loadedIdx[index] == nil {
                                        Task {
                                            do {
                                                page=page+1
                                                loadedIdx[index] = true
                                                print("loading page: \(page)")
                                                try await postVm.fetchMorePosts(page,"FREE")
                                            } catch (let error) {
                                                print("Unable to get data : \(error)")
                                            }
                                        }
                                        
                                    }
                                }
                        }
                        
                    }
                    .refreshable {
                        print("refreshing")
                        refreshVm()
                        
                    }
                
            }
    }
}

struct freeBoardView_Previews: PreviewProvider {

    static var previews: some View {
        let postVm = postViewModel()
        freeBoardView().environmentObject(postVm)
    }
}
