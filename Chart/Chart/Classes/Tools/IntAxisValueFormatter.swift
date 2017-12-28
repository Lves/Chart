//
//  IntAxisValueFormatter.swift
//  Chart
//
//  Created by lixingle on 2017/12/28.
//  Copyright © 2017年 com.lvesli. All rights reserved.
//

import Foundation
import Charts

public class IntAxisValueFormatter: NSObject, IAxisValueFormatter {
    public func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return "\(Int(value))"
    }
}

