//
//  ListView.swift
//  Tips
//
//  Created by lss on 2022/11/17.
//

import SwiftUI

struct ListView: View {
    var body: some View {
        List {
            ForEach(0..<10, id:\.self) { index in
                ListItemView()
            }
        }
       
    }
}

struct ListView_Previews: PreviewProvider {
    static var previews: some View {
        ListView()
    }
}
