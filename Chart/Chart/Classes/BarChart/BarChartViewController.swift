//
//  BarChartViewController.swift
//  Chart
//
//  Created by lixingle on 2017/12/5.
//  Copyright © 2017年 com.lvesli. All rights reserved.
//

import UIKit
import Charts
class BarChartViewController: UIViewController, ChartViewDelegate{
    @IBOutlet weak var barChartView: BarChartView!
    var dataArray:[[String]]?
    
    
    struct Constant {
        static let colors:[UIColor] = [
            UIColor(hex6: 0xFC8162),
            UIColor(hex6: 0xFB8E70),
            UIColor(hex6: 0xFFD978),
            UIColor(hex6: 0xFEC85E),
            UIColor(hex6: 0xFC9880),
            UIColor(hex6: 0xFFD1C4),
            UIColor(hex6: 0xFCA48E),
            UIColor(hex6: 0xFEBBAA),
            UIColor(hex6: 0xFDAF9B),
            UIColor(hex6: 0xFFE38C)]
        static let kLableTextColor:UIColor = UIColor(hex6: 0x626776)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        barChartView.delegate = self
        let xAxis = barChartView.xAxis
        xAxis.avoidFirstLastClippingEnabled = true              //是否允许首末Lable偏移
        xAxis.labelPosition = .bottom                            //x轴线位置
        xAxis.labelFont = UIFont.systemFont(ofSize: 11)
        xAxis.drawGridLinesEnabled = false                       //是否显示x轴网格线
        xAxis.labelTextColor = Constant.kLableTextColor          //label颜色
        xAxis.axisLineWidth = 0                                  //线宽度
//        xAxis.yOffset = 8                                        //xlabel 距离x轴线的距离
        xAxis.granularity = 1
        
        let leftAxis = barChartView.leftAxis
        leftAxis.axisLineWidth = 0.5                             //左侧线宽度
        leftAxis.labelTextColor = Constant.kLableTextColor      //label颜色
        leftAxis.labelFont = UIFont.systemFont(ofSize: 11)
        leftAxis.drawGridLinesEnabled = true                    //是否显示轴网格线
        
        barChartView.backgroundColor = UIColor(hex6:0x2F3549)
        barChartView.rightAxis.enabled = false                 //是否显示右侧轴线
        barChartView.dragEnabled = true                        //是否可以滑动
        barChartView.drawGridBackgroundEnabled = false         //背景色
        barChartView.doubleTapToZoomEnabled = true            //双击缩放
        barChartView.legend.enabled = true                     //是否显示图例
        barChartView.legend.textColor = Constant.kLableTextColor
        barChartView.chartDescription?.text = ""               //图表介绍
        
        
        
        if let dataArray = dataArray,dataArray.count > 0 {
            var dataSets:[IChartDataSet] = []
            for row in 1..<dataArray.count {
                let nextLine = dataArray[row]
                let values = (1..<nextLine.count).map({ (index) -> BarChartDataEntry in
                    let value = Double(nextLine[index])
                    return BarChartDataEntry(x: Double(index), y: value ?? 0)
                })
                let color = Constant.colors[row%10]
                let set = getBarChartDataSet(values: values,color: color, label: nextLine[0])
           
                dataSets.append(set)
            }
    
            let data = BarChartData(dataSets: dataSets)
            data.barWidth = ((1.0-0.08)/Double(dataArray.count))-0
            data.groupBars(fromX: 0.5, groupSpace: 0.08, barSpace: 0)
            
            barChartView.xAxis.axisMinimum = -0.1
            barChartView.xAxis.axisMaximum =  Double(dataArray.first?.count ?? 1)
            
            barChartView.data = data
        }
        
//        let entry1 = BarChartDataEntry(x: 1, y: 10)
//        let entry2 = BarChartDataEntry(x: 2, y: 20)
//        let entry3 = BarChartDataEntry(x: 3, y: 30)
//        let set1 = BarChartDataSet(values: [entry1,entry2,entry3], label: "Company A")
//        set1.setColor(UIColor(red: 104/255, green: 241/255, blue: 175/255, alpha: 1))
//
//        let entry4 = BarChartDataEntry(x: 1, y: 40)
//        let entry5 = BarChartDataEntry(x: 2, y: 50)
//        let entry6 = BarChartDataEntry(x: 3, y: 60)
//        let dataSe1 = getBarChartDataSet(values: [entry4, entry5, entry6],color: Constant.colors[3], label: "测试2")
//        let data = BarChartData(dataSets: [set1,dataSe1])
//        data.barWidth = 0.3
//        data.groupBars(fromX: 1, groupSpace: 0.08, barSpace: 0.03)
//        barChartView.data = data
        
        
    }
    
    func getBarChartDataSet(values: [ChartDataEntry]?,color: UIColor, label: String?) -> BarChartDataSet {
        let set = BarChartDataSet(values: values, label: label)
        set.setColor(color) //折线的颜色
        set.valueTextColor = color
        set.valueFont = UIFont.systemFont(ofSize: 11)
        set.drawValuesEnabled = true //是否显示数字
        return set
    }

}
