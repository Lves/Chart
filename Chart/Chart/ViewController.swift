//
//  ViewController.swift
//  Chart
//
//  Created by lixingle on 2017/11/30.
//  Copyright © 2017年 com.lvesli. All rights reserved.
//

import UIKit

class ViewController:UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var scrollView: UIScrollView!
    var collectionView: UICollectionView!
    var dataArray:[[String]] = []
    var cols:Int = 1
    var rows:Int = 2
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
        
        collectionView.reloadData()
        //列计数器
        let stepperFrame = CGRect(x: collectionView.frame.maxX + Constant.kSetpperMargin, y: 0, width: 50, height: 30)
        colsStepper = UIStepper(frame: stepperFrame)
        colsStepper?.tintColor = UIColor.gray
        colsStepper?.minimumValue = 1
        colsStepper?.maximumValue = 100
        colsStepper?.value = Double(cols)
        colsStepper?.stepValue = 1
        colsStepper?.addTarget(self, action: #selector(stepperValueChanged(sender:)), for: .valueChanged)
        scrollView.addSubview(colsStepper!)
        //行计数器
        let rowStepperFrame = CGRect(x:0 , y: collectionView.frame.maxY + Constant.kSetpperMargin, width: 40, height: 30)
        rowsStepper = UIStepper(frame: rowStepperFrame)
        rowsStepper?.tintColor = UIColor.gray
        rowsStepper?.minimumValue = 1
        rowsStepper?.maximumValue = 100
        rowsStepper?.value = Double(rows)
        rowsStepper?.stepValue = 1
        rowsStepper?.addTarget(self, action: #selector(stepperValueChanged(sender:)), for: .valueChanged)
        scrollView.addSubview(rowsStepper!)
        
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return collectionSections
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionCols
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:TextFieldCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "TextFieldCollectionViewCell", for: indexPath) as! TextFieldCollectionViewCell
        cell.backgroundColor = UIColor.white
        cell.textField.delegate = self
        let rowArray = dataArray[indexPath.section]
        cell.textField.textColor = UIColor.black
        if indexPath.section != 0 && indexPath.row != 0 {
            cell.textField.placeholder = "\(indexPath.section) -- \(indexPath.row)"
        }else {
            cell.textField.placeholder = rowArray[indexPath.row]
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
            let stepperFrame = CGRect(x: collectionView.frame.maxX + Constant.kSetpperMargin, y: 0, width: 50, height: 30)
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
}

extension ViewController: UITextFieldDelegate {
    public func textFieldDidEndEditing(_ textField: UITextField) {
        if let cell = textField.superview?.superview as? TextFieldCollectionViewCell ,let indexPath = collectionView.indexPath(for: cell){
            var rowArray = dataArray[indexPath.section]
            rowArray[indexPath.row] = textField.text ?? ""
            dataArray[indexPath.section] = rowArray
        }
    }
}

