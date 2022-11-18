//
//  SwiftUIC.swift
//  Tips
//
//  Created by lss on 2022/11/16.
//

import Foundation
import UIKit
import SwiftUI


@objc
class SwiftUIC : NSObject {
    @objc class func chartController() -> UIViewController {
        return UIHostingController(rootView: LineChart1())
    }
    @objc class func rootTabController() -> UIViewController {
        return UIHostingController(rootView: TabBarView())
    }
}
