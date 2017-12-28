//
//  LineChartViewController.swift
//  Chart
//
//  Created by lixingle on 2017/12/3.
//  Copyright © 2017年 com.lvesli. All rights reserved.
//

import UIKit
import Charts

class LineChartViewController: UIViewController,ChartViewDelegate {
    @IBOutlet weak var lineChartView: LineChartView!
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
        title = "图表"
        
        
        
        lineChartView.delegate = self
        let xAxis = lineChartView.xAxis
        xAxis.avoidFirstLastClippingEnabled = true              //是否允许首末Lable偏移
        xAxis.labelPosition = .bottom                            //x轴线位置
        xAxis.labelFont = UIFont.systemFont(ofSize: 11)
        xAxis.drawGridLinesEnabled = false                       //是否显示x轴网格线
        xAxis.labelTextColor = Constant.kLableTextColor          //label颜色
        xAxis.axisLineWidth = 0.5                                  //线宽度
        xAxis.yOffset = 8                                        //xlabel 距离x轴线的距离
        xAxis.labelCount = dataArray?.first?.count ?? 1
        xAxis.granularity = 1
        xAxis.axisMinimum = 0.95

        
        xAxis.valueFormatter = self
        
        let leftAxis = lineChartView.leftAxis
        leftAxis.axisLineWidth = 0.5                             //左侧线宽度
        leftAxis.labelTextColor = Constant.kLableTextColor      //label颜色
        leftAxis.labelFont = UIFont.systemFont(ofSize: 11)
        leftAxis.drawGridLinesEnabled = true                    //是否显示轴网格线
        
        lineChartView.backgroundColor = UIColor(hex6:0x2F3549)
        lineChartView.rightAxis.enabled = false                 //是否显示右侧轴线
        lineChartView.dragEnabled = true                        //是否可以滑动
        lineChartView.drawGridBackgroundEnabled = false         //背景色
        lineChartView.doubleTapToZoomEnabled = false            //双击缩放
        lineChartView.legend.enabled = true                     //是否显示图例
        lineChartView.legend.textColor = Constant.kLableTextColor
        lineChartView.chartDescription?.text = ""               //图表介绍

        
        
        if let dataArray = dataArray {
            
            var dataSets:[IChartDataSet] = []
            for row in 1..<dataArray.count {
                let nextLine = dataArray[row]
                let values = (1..<nextLine.count).map({ (index) -> ChartDataEntry in
                    let value = Double(nextLine[index])
                    return ChartDataEntry(x: Double(index), y: value ?? 0, icon: nil)
                })
                let color = Constant.colors[row%10]
                let set = getLineDataSet(values: values,color: color, label: nextLine[0])
                
                dataSets.append(set)
            }
            let data = LineChartData(dataSets: dataSets)
            lineChartView.data = data
            lineChartView.animate(xAxisDuration: 0.3)
        }
    }
    
    func getLineDataSet(values: [ChartDataEntry]?,color: UIColor, label: String?) -> LineChartDataSet {
         let set = LineChartDataSet(values: values, label: label)
//        set.drawFilledEnabled = true
//        set.fillColor = color
//        set.fillAlpha = 0.5
        set.setColor(color) //折线的颜色
        set.valueTextColor = color
        set.valueFont = UIFont.systemFont(ofSize: 11)
        set.drawCircleHoleEnabled = false
//        set.circleHoleRadius = 2.5
//        set.circleHoleColor = color
        set.circleRadius = 4.0
        set.circleColors = [color]
        set.lineWidth = 1.5

        
        set.drawValuesEnabled = true //是否显示数字
        set.drawHorizontalHighlightIndicatorEnabled = false //是否显示水平高亮线
        set.highlightColor = UIColor.white
        set.fillFormatter = ChartLvesFillFormatter()
        return set
    }
}

extension LineChartViewController: IAxisValueFormatter{
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        if let dataArray = dataArray {
            if let dataLabels = dataArray.first {
                return dataLabels[min(max(Int(value), 0), dataLabels.count - 1)]
            }
        }
        return ""
    }
}

//MARK:  FillFormat
public class ChartLvesFillFormatter: NSObject, IFillFormatter
{
    public override init(){ }
    public func getFillLinePosition(dataSet: ILineChartDataSet, dataProvider: LineChartDataProvider) -> CGFloat
    {
        return CGFloat(dataProvider.chartYMin)
    }

}
