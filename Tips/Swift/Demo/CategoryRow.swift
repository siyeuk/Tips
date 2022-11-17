//
//  CategoryRow.swift
//  Tips
//
//  Created by lss on 2022/11/17.
//

import SwiftUI

struct CategoryRow: View {
    
    var categoryName: String
    var item: [Landmark]
    
    // 垂直布局包括：leading、trailing、center
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(self.categoryName)
                .font(.headline)
                .padding(.leading, 15)
                .padding(.top, 5)
            // ScrollView 左右滑动，不显示滚动条
            ScrollView(.horizontal, showsIndicators: false) {
                // 居上 间隔为0
                HStack(alignment: .top, spacing: 0) {
                    ForEach(self.item) { landmark in
                        // 推出下个页面
                        NavigationLink {
                            LandmarkDetail(landmark: landmark)
                        } label: {
                            // 展示的什么
                            CategoryItem(landmark: landmark)
                        }
                    }
                }
            }
            .frame(height: 185)
        }
    }
}

struct CategoryItem: View {
    var landmark: Landmark
    var body: some View {
        VStack(alignment: .leading) {
            landmark.image
                .renderingMode(.original) // 原始
                .resizable() // 可调整大小
                .frame(width: 155, height: 155) // 大小
                .cornerRadius(5) // 圆角
            Text(landmark.name)
                .foregroundColor(.primary) // 用于主要内容颜色
                .font(.caption)  // 字体大小
        }
        .padding(.leading, 15)
    }
}

struct CategoryRow_Previews: PreviewProvider {
    static var previews: some View {
        CategoryRow(
            categoryName: landmarkData[0].category.rawValue,
            item: Array(landmarkData.prefix(4))
        )
        .environmentObject(UserData())
    }
}
