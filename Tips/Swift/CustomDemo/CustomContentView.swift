//
//  CustomContentView.swift
//  Tips
//
//  Created by lss on 2022/11/17.
//

import SwiftUI

struct CustomContentView: View {
    var body: some View {
        NavigationView {
            List {
                NavigationLink {
                    ListView()
                } label: {
                    HStack {
                        Text("ListView")
                        Spacer()
                        Text("list")
                    }
                }
                
                NavigationLink {
                    CustomContentView()
                } label: {
                    HStack {
                        Text("2")
                        Spacer()
                        Text("tip")
                    }
                }
                
                NavigationLink {
                    CustomContentView()
                } label: {
                    HStack {
                        Text("3")
                        Spacer()
                        Text("tip")
                    }
                }
                
                NavigationLink {
                    CustomContentView()
                } label: {
                    HStack {
                        Text("4")
                        Spacer()
                        Text("tip")
                    }
                }
                
                NavigationLink {
                    CustomContentView()
                } label: {
                    HStack {
                        Text("5")
                        Spacer()
                        Text("tip")
                    }
                }
            }.navigationTitle("SwiftUI")
        }
    }
}

struct CustomContentView_Previews: PreviewProvider {
    static var previews: some View {
        CustomContentView()
    }
}
