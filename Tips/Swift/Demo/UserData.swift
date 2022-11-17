//
//  UserData.swift
//  Tips
//
//  Created by lss on 2022/11/17.
//

import SwiftUI
import Combine

final class UserData: ObservableObject {
    @Published var showFavoritesOnly = false
    @Published var landmarks = landmarkData
}
