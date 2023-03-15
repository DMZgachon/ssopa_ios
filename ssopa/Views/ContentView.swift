//
//  ContentView.swift
//  ssopa
//
//  Created by Jiho Seo on 2023/03/09.
//

import SwiftUI

struct ContentView: View {
    @State var isLoading: Bool = true
    var body: some View {
        
        LoginMain()

    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(ModelData())
    }
}
