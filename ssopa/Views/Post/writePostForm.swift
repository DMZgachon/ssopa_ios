//
//  writePostForm.swift
//  ssopa
//
//  Created by Jiho Seo on 2023/03/13.
//

import SwiftUI

struct writePostForm: View {
    
    @State private var content = ""
    @State private var title = ""
    @Binding var isPresented: Bool
    
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
                    } label: {
                        Text("글 등록")
                    }.padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 8.0))
                        .foregroundColor(Color.ssopa_orange)

                }
                .padding(EdgeInsets(top: 30, leading: 0, bottom: 0, trailing: 0))
                Divider()
                HStack{
                    Text("게시판 선택")
                }
                Divider()
                HStack{
                    TextField("제목", text: $title)
                        .font(Font.headline)
                    
                }
                Divider()
                ScrollView {
                    HStack{
                        TextField("내용", text: $content )
                            .keyboardType(UIKeyboardType.default)
                    }
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
