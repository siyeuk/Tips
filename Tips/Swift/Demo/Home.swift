//
//  Home.swift
//  Tips
//
//  Created by lss on 2022/11/17.
//

import SwiftUI

struct Home: View {
    
    var categories: [String: [Landmark]] {
        Dictionary(
            grouping: landmarkData,
            by: { $0.category.rawValue}
        )
    }
    
    var featured: [Landmark] {
        landmarkData.filter { $0.isFeatured }
    }
    
    @State var showingProfile = false
    
    var profileButton: some View {
        Button {
            self.showingProfile.toggle()
        } label: {
            Image(systemName: "person.crop.circle")
                .imageScale(.large)
                .accessibilityLabel(Text("用户配置"))
                .padding()
        }

    }
    
    var body: some View {
        NavigationView {
            List {
                FeaturedLandmarks(landmarks: featured)
                    .scaledToFill()
                    .frame(height: 200)
                    .clipped()
                    .listRowInsets(EdgeInsets())
                
                ForEach(categories.keys.sorted(), id: \.self) { key in
                    CategoryRow(categoryName: key, item: self.categories[key]!)
                }
                .listRowInsets(EdgeInsets())
                
                NavigationLink {
                    LandmarkList()
                } label: {
                    Text("查看所有")
                }

            }
            .navigationTitle(Text("特色"))
            .navigationBarItems(trailing: profileButton)
            .sheet(isPresented: $showingProfile) {
                Text("用户配置")
            }
        }
    }
}

struct FeaturedLandmarks: View {
    var landmarks: [Landmark]
    var body: some View {
        landmarks[0].image.resizable()
    }
}


struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}
