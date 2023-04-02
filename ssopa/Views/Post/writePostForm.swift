//
//  writePostForm.swift
//  ssopa
//
//  Created by Jiho Seo on 2023/03/13.
//

import SwiftUI

enum Board: String, CaseIterable {
    case FREE = "자유게시판"
    case SECRET = "비밀게시판"
    // Add more board options here
}

extension Board: CustomStringConvertible {
    var description: String {
        switch self {
        case .FREE:
            return "FREE"
        case .SECRET:
            return "SECRET"
        }
    }
}

struct writePostForm: View {
    
    @State private var content = ""
    @State private var title = ""
    @Binding var isPresented: Bool
    @State private var selectedBoard: Board = .FREE
    let httpclient = HTTPClient.shared
    
    
    
    // Define the closure
    let completionHandler: (Result<PostResponse, Error>) -> Void = { result in
        // Handle the result
    }
    
    
    func writePost(_ category: Board,_ content: String, _ title: String){
        let post = postRequest(title: title, category: category.description, content: content)
        httpclient.writePost(request: post, completion: completionHandler)
    }
    
    
    var body: some View {
            
            VStack(alignment: .leading) {
            
                HStack{
                    Button {
                        isPresented = false
                    } label: {
                        Image(systemName: "xmark.bin")
                            .foregroundColor(Color.ssopa_orange)
                    }.padding(EdgeInsets(top: 0, leading: 8.0, bottom: 0, trailing: 0))
                    Spacer()
                    Button {
                        isPresented = false
                        writePost(selectedBoard, content, title)
                    } label: {
                        Text("글 등록")
                    }.padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 8.0))
                        .foregroundColor(Color.ssopa_orange)

                }
                .padding(EdgeInsets(top: 30, leading: 0, bottom: 0, trailing: 0))
                Divider()
                Picker("게시판 선택", selection: $selectedBoard) {
                                ForEach(Board.allCases, id: \.self) { board in
                                    Text(board.rawValue)
                                }
                            }
                Divider()
                HStack{
                    TextField("제목", text: $title)
                        .font(Font.headline)
                    
                }.padding(EdgeInsets(top: 0, leading: 8.0, bottom: 0, trailing: 0))
                Divider()
                ScrollView {
                    HStack{
                        TextField("내용", text: $content )
                            .keyboardType(UIKeyboardType.default)
                    }.padding(EdgeInsets(top: 0, leading: 8.0, bottom: 0, trailing: 0))
                }
                Spacer()
            }
        }
    
}

struct writePostForm_Previews: PreviewProvider {
    
    static var previews: some View {
        
        writePostForm(isPresented: .constant(true))
    }
    
}
