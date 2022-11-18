//
//  ListItemView.swift
//  Tips
//
//  Created by lss on 2022/11/17.
//

import SwiftUI

struct ListItemView: View {
    var body: some View {
        HStack {
            Image(uiImage: UIImage(named: "ListItemHeader")!)
                .clipped()
            VStack(alignment: .leading) {
                Spacer()
                HStack {
                    Text("用户名")
                    Spacer()
                    Text("userId")
                }
                Spacer()
                Text("phone number")
                Spacer()
            }
        }.navigationTitle("List")
    }
}

struct ListItemView_Previews: PreviewProvider {
    static var previews: some View {
        ListItemView()
    }
}
