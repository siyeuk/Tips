//
//  TabBarView.swift
//  Tips
//
//  Created by lss on 2022/11/16.
//

import SwiftUI

struct TabBarView: View {
    
    let highColor = UIColor.hex(hexString: "#383838")
    
    @State private var selectIndex = 0
    
    var body: some View {
        TabView(selection: $selectIndex) {
            VStack {
                Home().environmentObject(UserData())
            }
//            .padding()
            .tabItem {
                if selectIndex == 0 {
                    Image("tab_book_sel")
                }else {
                    Image("tab_book_nor")
                }
                Text("HOME")
            }
            .tag(0)
            
            VStack {
                CustomContentView()
            }
//            .padding()
            .tabItem {
                if selectIndex == 1 {
                    Image("tab_my_sel")
                }else {
                    Image("tab_my_nor")
                }
                Text("MY")
            }
            .tag(1)
        }
        // Use the asset catalog's accent color or View.tint(_:) instead.
        //        if #available(iOS 16.0, *) {
        //            .tint(Color(highColor))
        //        }
        .accentColor(Color(highColor))
        .font(Font.system(size: 16))
        
    }
}

struct TabBarView_Previews: PreviewProvider {
    static var previews: some View {
        TabBarView()
    }
}
