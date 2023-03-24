//
//  PostList.swift
//  ssopa
//
//  Created by Jiho Seo on 2023/03/11.
//

import SwiftUI



struct PostList: View {
    
    
    
    
    
    @State private var selectedTab = 0
    
    @State private var isPresentingWriteForm = false
    
    @EnvironmentObject var postVm: postViewModel
    
    
    static var getdata = ModelData().postdata
    
    var body: some View {
        
        
        TabView(selection: $selectedTab) {
            NavigationView{
                ZStack{
                    freeBoardView().environmentObject(postVm)
                        .navigationTitle("자유게시판")
                    VStack {
                        Spacer()
                        HStack {
                            Spacer()
                            Button(action: {
                                isPresentingWriteForm = true
                                
                            }) {
                                Image(systemName: "pencil")
                                    .foregroundColor(.white)
                                    .padding(25)
                                    .background(Color.ssopa_orange)
                                    .clipShape(Circle())
                            }
                            .padding()
                        }
                    }

                }
                .sheet(isPresented: $isPresentingWriteForm) {
                    writePostForm(isPresented: $isPresentingWriteForm)
                }
            }
                .tabItem {
                    Image(systemName: "signpost.left.fill")
                    Text("자유게시판")
                }.tag(0)
            
            NavigationView {
                List {
                    // content for second tab goes here
                }
                .navigationTitle("비밀게시판")
            }
            .tabItem {
                Image(systemName: "signpost.right.fill")
                Text("비밀게시판")
            }.tag(1)
            
            NavigationView {
                List {
                    // content for third tab goes here
                }
                .navigationTitle("오픈채팅")
            }
            .tabItem {
                Image(systemName: "message.fill")
                    .foregroundColor(Color.ssopa_orange)
                Text("오픈채팅")
            }.tag(2)
            
            NavigationView {
                List {
                    // content for third tab goes here
                }
                .navigationTitle("설정")
            }
            .tabItem {
                Image(systemName: "gear")
                    .foregroundColor(Color.ssopa_orange)
                Text("설정")
            }.tag(3)
        }.onChange(of: selectedTab) { newTab in
            // Call your function here
            print("Selected tab: \(newTab)")
            
        }
        
    }
    
    
    
    
    struct PostList_Previews: PreviewProvider {
        static var getdata = ModelData().postdata
        static var previews: some View {
            
            // 커밋테스트
            ForEach(["iPhone SE (2nd generation)", "iPhone 14 Pro"], id: \.self) { deviceName in
                PostList()
                    .previewDisplayName(deviceName)
                    .environmentObject(ModelData())
                    .environmentObject(postViewModel())
            }
        }
    }
}
