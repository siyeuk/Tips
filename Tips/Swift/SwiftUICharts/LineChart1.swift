//
//  LineChart1.swift
//  MTSwiftUI
//
//  Created by lss on 2022/11/16.
//

import SwiftUI
import Charts


struct LineChart1: View {
    var body: some View {
        VStack {
            if #available(iOS 15.0, *) {
                GroupBox ( "折线图 - 步数") {
                    if #available(iOS 16.0, *) {
                        Chart {
                            ForEach(currentWeek) {
                                LineMark(
                                    x: .value("Week Day", $0.weekday, unit: .day),
                                    y: .value("步数", $0.steps)
                                )
                            }
                        }
                    } else {
                        // Fallback on earlier versions
                    }
                }
            } else {
                // Fallback on earlier versions
            }
            
            if #available(iOS 15.0, *) {
                GroupBox ( "柱状图 - 步数") {
                    if #available(iOS 16.0, *) {
                        Chart(currentWeek) {
                            BarMark(
                                x: .value("Week Day", $0.weekday, unit: .day),
                                y: .value("步数", $0.steps)
                            )
                        }
                    } else {
                        // Fallback on earlier versions
                    }
                }
            } else {
                // Fallback on earlier versions
            }
            
            if #available(iOS 15.0, *) {
                GroupBox ( "散点图 - 步数") {
                    if #available(iOS 16.0, *) {
                        Chart(currentWeek) {
                            PointMark(
                                x: .value("Week Day", $0.weekday, unit: .day),
                                y: .value("步数", $0.steps)
                            )
                        }
                    } else {
                        // Fallback on earlier versions
                    }
                }
            } else {
                // Fallback on earlier versions
            }
            
            if #available(iOS 15.0, *) {
                GroupBox ( "矩状图 - 步数") {
                    if #available(iOS 16.0, *) {
                        Chart(currentWeek) {
                            RectangleMark(
                                x: .value("Week Day", $0.weekday, unit: .day),
                                y: .value("步数", $0.steps)
                            )
                        }
                    } else {
                        // Fallback on earlier versions
                    }
                }
            } else {
                // Fallback on earlier versions
            }
            
            if #available(iOS 15.0, *) {
                GroupBox ( "面积图 - 步数") {
                    if #available(iOS 16.0, *) {
                        Chart(currentWeek) {
                            AreaMark(
                                x: .value("Week Day", $0.weekday, unit: .day),
                                y: .value("步数", $0.steps)
                            )
                        }
                    } else {
                        // Fallback on earlier versions
                    }
                }
            } else {
                // Fallback on earlier versions
            }
        }
    }
}

struct LineChart1_Previews: PreviewProvider {
    static var previews: some View {
        LineChart1()
    }
}
