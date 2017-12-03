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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "图表"
        lineChartView.delegate = self
        
        let array = dataArray?[1]
        let values = (0..<(array?.count ?? 1)).map({ (index) -> ChartDataEntry in
            let value = Double(array?[index] ?? "0")
            return ChartDataEntry(x: Double(index), y: value ?? 0, icon: nil)
        })
        
        let set = LineChartDataSet(values: values, label: "折线图")
        
        
        set.drawFilledEnabled = true
        set.fillColor = UIColor(hex6:0xFD734C)
        set.fillAlpha = 0.5
        set.setColor(UIColor(hex6:0xFD734C))
        
//        set.drawCirclesEnabled = false
        set.circleRadius = 10.0 //圆半径
        set.lineWidth = 1.5
        set.drawValuesEnabled = false //是否显示数字
        set.drawHorizontalHighlightIndicatorEnabled = false //是否显示水平高亮线
        set.highlightColor = UIColor.white
        set.fillFormatter = ChartLvesFillFormatter()
        
        
        let data = LineChartData(dataSet: set)
        
        lineChartView.data = data

        
        let xAxis = lineChartView.xAxis
        xAxis.avoidFirstLastClippingEnabled = true      //是否允许首末Lable偏移
        xAxis.labelPosition = .bottom                   //x轴线位置
        xAxis.labelFont = UIFont.systemFont(ofSize: 11)
        xAxis.drawGridLinesEnabled = false              //是否显示x轴网格线
        xAxis.labelTextColor = UIColor(hex6: 0x626776)  //label颜色
        xAxis.axisLineWidth = 0                         //线宽度
        xAxis.yOffset = 8                               //xlabel 距离x轴线的距离
        
        let leftAxis = lineChartView.leftAxis
        leftAxis.axisLineWidth = 0.5                 //左侧线宽度
        leftAxis.labelTextColor = UIColor(hex6: 0x626776)  //label颜色
        leftAxis.labelFont = UIFont.systemFont(ofSize: 11)
        leftAxis.drawGridLinesEnabled = true              //是否显示轴网格线
        
        lineChartView.backgroundColor = UIColor(hex6:0x2F3549)
        lineChartView.rightAxis.enabled = false                 //是否显示右侧轴线
        lineChartView.dragEnabled = true                        //是否可以滑动
        lineChartView.drawGridBackgroundEnabled = false         //背景色
        lineChartView.doubleTapToZoomEnabled = false            //双击缩放
        lineChartView.legend.enabled = false                    //是否显示说明

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
