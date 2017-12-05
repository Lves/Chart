//
//  PieChartViewController.swift
//  Chart
//
//  Created by lixingle on 2017/12/4.
//  Copyright © 2017年 com.lvesli. All rights reserved.
//

import UIKit
import Charts
class PieChartViewController: UIViewController {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pieChartView: PieChartView!
    
    var dataArray:[PieChartDataModel]?
    
    struct ColorCharts {
        static let BarColors = [UIColor(hex6: 0xFC8162),
                                UIColor(hex6: 0xFA8E30),
                                UIColor(hex6: 0xFFD978),
                                UIColor(hex6: 0xFEC85E),
                                UIColor(hex6: 0xFC9880),
                                UIColor(hex6: 0xFFD1C4),
                                UIColor(hex6: 0xFCA48E),
                                UIColor(hex6: 0xFEBBAA),
                                UIColor(hex6: 0xFDAF9B),
                                UIColor(hex6: 0xFFE38C)]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "饼图"
        
        pieChartView.legend.enabled = true
        pieChartView.noDataText = "暂无数据"
        pieChartView.noDataTextColor = UIColor(hex6: 0x333333)
        pieChartView.chartDescription?.text = ""
        pieChartView.drawHoleEnabled = false
        pieChartView.rotationAngle = 90 //起始绘制角度
        pieChartView.drawEntryLabelsEnabled = true          //是否显示类别
        pieChartView.highlightPerTapEnabled = false
        pieChartView.legend.horizontalAlignment = .center
        pieChartView.legend.verticalAlignment = .bottom
        pieChartView.legend.drawInside = true
        pieChartView.legend.yOffset = 0
        
        if let dataArray = dataArray,dataArray.count > 0 {
            //1.0 求和
            let sum = dataArray.reduce(into: 0, { (sum, model) in
                sum += Double(model.value ?? "0")!
            })
            //2.0 创建entry
            let entries = (0..<dataArray.count).map({ (index) -> PieChartDataEntry in
                let dataChart = dataArray[index]
                let value:Double = Double(dataChart.value ?? "0")! * 100 / sum
                return PieChartDataEntry(value: value, label: dataChart.name ?? "")
            })
            
            
            let pieChartDataSet = PieChartDataSet(values: entries, label: "")
            pieChartDataSet.sliceSpace = 2                 //中间是否显示空格
            pieChartDataSet.drawValuesEnabled = true       //是否显示数据
            pieChartDataSet.colors = ColorCharts.BarColors
            
//            pieChartDataSet.yValuePosition = .outsideSlice
//            pieChartDataSet.valueLinePart1OffsetPercentage = 0.8
//            pieChartDataSet.valueLinePart1Length = 0.2
//            pieChartDataSet.valueLinePart2Length = 0.4
//            pieChartDataSet.valueTextColor = UIColor.black

            let data = PieChartData(dataSet: pieChartDataSet)
            let pFormatter = NumberFormatter()
            pFormatter.numberStyle = .percent
            pFormatter.maximumFractionDigits = 1
            pFormatter.multiplier = 1
            pFormatter.percentSymbol = " %"
            data.setValueFormatter(DefaultValueFormatter(formatter: pFormatter))
            
            pieChartView.data = data
            pieChartView.animate(yAxisDuration: 2)
        }else {
            pieChartView.data = nil
        }
        
 

    }
}
