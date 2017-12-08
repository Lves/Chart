//
//  ViewController.swift
//  Chart
//
//  Created by lixingle on 2017/11/30.
//  Copyright © 2017年 com.lvesli. All rights reserved.
//

import UIKit

enum EditType:String {
    case toBarChart
    case toLineChart
}

class LineChartEditViewController:UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    @IBOutlet weak var scrollView: UIScrollView!
    var collectionView: UICollectionView!
    ///编辑页类型
    var type:EditType = .toLineChart
    
    
    var dataArray:[[String]] = []
    var cols:Int = 3
    var rows:Int = 1
    var collectionSections:Int {
        get{
            return rows + 1
        }
    }
    var collectionCols:Int {
        get{
            return cols + 1
        }
    }
    
    //计步器
    var rowsStepper:UIStepper? 
    var colsStepper:UIStepper?
    
    struct Constant {
        static let kCellWidth:CGFloat = 80
        static let kCellHight:CGFloat = 45
        static let kCellSpace:CGFloat = 0.5
        static let kFloatViewSize:CGFloat = 10
        static let kSetpperMargin:CGFloat = 5
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "数据录入"
        
        //初始化数据
        for row in 0...rows {
            var rowArray = Array(repeating: "", count: cols+1)
            //行头
            if row == 0 {
                rowArray[0] = "行\\列"
            }else {
                rowArray[0] = "第\(row)行"
            }
            //列头
            if row == 0 {
                for col in 1...cols{
                    rowArray[col] = "第\(col)列"
                }
            }
            dataArray.append(rowArray)
        }
        //CollectionView
        buildCollectionView()
        collectionView.reloadData()
        //列计数器
        let stepperFrame = CGRect(x: collectionView.frame.maxX + Constant.kSetpperMargin, y: Constant.kSetpperMargin, width: 50, height: 30)
        colsStepper = steppView(frame: stepperFrame)
        colsStepper?.value = Double(cols)
        scrollView.addSubview(colsStepper!)
        //行计数器
        let rowStepperFrame = CGRect(x:0 , y: collectionView.frame.maxY + Constant.kSetpperMargin, width: 40, height: 30)
        rowsStepper = steppView(frame: rowStepperFrame)
        rowsStepper?.value = Double(rows)
        scrollView.addSubview(rowsStepper!)
        
    }
    func buildCollectionView()  {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = Constant.kCellSpace
        layout.minimumInteritemSpacing = Constant.kCellSpace
        layout.headerReferenceSize = CGSize.zero
        layout.footerReferenceSize = CGSize(width: 100, height: 0.5)
        
        let frame = CGRect(x: 0, y: 0,
                           width: CGFloat(collectionCols)*(Constant.kCellWidth + Constant.kCellSpace),
                           height: CGFloat(collectionSections)*(Constant.kCellHight + Constant.kCellSpace))
        collectionView = UICollectionView(frame: frame, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.gray
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UINib(nibName: "TextFieldCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "TextFieldCollectionViewCell")
        scrollView.contentSize = CGSize(width: collectionView.frame.maxX + 160, height: collectionView.frame.maxY + 50)
        scrollView.addSubview(collectionView)
    }
    
    func steppView(frame:CGRect) -> UIStepper {
        let stepper = UIStepper(frame: frame)
        stepper.tintColor = UIColor.gray
        stepper.minimumValue = 1
        stepper.maximumValue = 100
        
        stepper.stepValue = 1
        stepper.addTarget(self, action: #selector(stepperValueChanged(sender:)), for: .valueChanged)
        return stepper
    }
    
    
    //MARK: - UICollectionView Delegate

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return collectionSections
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionCols
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:TextFieldCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "TextFieldCollectionViewCell", for: indexPath) as! TextFieldCollectionViewCell
        
        cell.textField.delegate = self
        let rowArray = dataArray[indexPath.section]
        cell.textField.textColor = UIColor.black
        if indexPath.section != 0 && indexPath.row != 0 {
            cell.textField.placeholder = "\(indexPath.section) -- \(indexPath.row)"
            cell.backgroundColor = UIColor.white
            cell.textField.keyboardType = .decimalPad
        }else {
            cell.textField.placeholder = rowArray[indexPath.row]
            cell.backgroundColor = UIColor(hex6:0xefefef)
            cell.textField.keyboardType = .default
        }
        let str:String = rowArray[indexPath.row]
        if str.count > 0 {
            cell.textField.text = str
        }else {
            cell.textField.text = ""
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        return CGSize(width: Constant.kCellWidth, height: Constant.kCellHight)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }
    @objc func stepperValueChanged(sender:UIStepper) {
        view.endEditing(true)
        if sender == colsStepper {
            cols = Int(sender.value)
            updateUI(isCols: true)
        }else if sender == rowsStepper{
            rows = Int(sender.value)
            updateUI(isCols: false)
        }
    }
    
    //MARK: - updateUI
    func updateUI(isCols:Bool)  {
        let frame = CGRect(x: 0, y: 0,
                           width: CGFloat(collectionCols)*(Constant.kCellWidth + Constant.kCellSpace),
                           height: CGFloat(collectionSections)*(Constant.kCellHight + Constant.kCellSpace))
        collectionView.frame = frame
        scrollView.contentSize = CGSize(width: collectionView.frame.maxX + 110, height: collectionView.frame.maxY + 50)
        if isCols {//修改列
            for index in 0..<dataArray.count {
                var array = dataArray[index]
                if collectionCols > array.count { //增加了
                    if index == 0 { //修改列头
                        array.append("第\(array.count)列")
                    }else {
                        array.append("")
                    }
                    dataArray[index] = array
                }else if collectionCols < array.count { //减少了
                    array.remove(at: array.count-1)
                    dataArray[index] = array
                }
            }
            let stepperFrame = CGRect(x: collectionView.frame.maxX + Constant.kSetpperMargin, y: Constant.kSetpperMargin, width: 50, height: 30)
            colsStepper?.frame = stepperFrame
            collectionView.reloadData()
            if let colsStepper = colsStepper ,colsStepper.frame.maxX > scrollView.frame.width {
                scrollView.setContentOffset(CGPoint(x: colsStepper.frame.maxX - view.frame.width, y: 0), animated: true)
            }
            
        }else {
            if collectionSections > dataArray.count { //增加了
                var rowArray = Array(repeating: "", count: collectionCols)
                rowArray[0] = "第\(dataArray.count)行"
                dataArray.append(rowArray)
            }else {
                dataArray.remove(at: dataArray.count - 1)
            }
            let stepperFrame = CGRect(x: 0, y: collectionView.frame.maxY + Constant.kSetpperMargin, width: 50, height: 30)
            rowsStepper?.frame = stepperFrame
            collectionView.reloadData()
            
            if let rowsStepper = rowsStepper ,rowsStepper.frame.maxY > scrollView.frame.height {
                scrollView.setContentOffset(CGPoint(x: 0, y: rowsStepper.frame.maxY - scrollView.frame.height), animated: true)
            }
        }
    }
    //MARK: - Action
    @IBAction func toLineChart(_ sender: Any) {
        view.endEditing(true)
        
        if type == .toLineChart {
            let lineChartVc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LineChartViewController") as! LineChartViewController
            lineChartVc.dataArray = dataArray
            navigationController?.pushViewController(lineChartVc, animated: true)
        }else if type == .toBarChart {
            let barChartVc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "BarChartViewController") as! BarChartViewController
            barChartVc.dataArray = dataArray
            navigationController?.pushViewController(barChartVc, animated: true)
        }
 
    }
    
}

extension LineChartEditViewController: UITextFieldDelegate {
    public func textFieldDidEndEditing(_ textField: UITextField) {
        if let cell = textField.superview?.superview as? TextFieldCollectionViewCell ,let indexPath = collectionView.indexPath(for: cell){
            var rowArray = dataArray[indexPath.section]
            rowArray[indexPath.row] = textField.text ?? ""
            dataArray[indexPath.section] = rowArray
        }
    }
}

