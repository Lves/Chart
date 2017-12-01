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
    var cols:Int = 5
    var rows:Int = 4
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
        let stepperFrame = CGRect(x: collectionView.frame.maxX, y: 0, width: 50, height: 30)
        rowsStepper = UIStepper(frame: stepperFrame)
        rowsStepper?.minimumValue = 1
        rowsStepper?.maximumValue = 100
        rowsStepper?.value = Double(cols)
        rowsStepper?.stepValue = 1
        rowsStepper?.addTarget(self, action: #selector(stepperValueChanged(sender:)), for: .valueChanged)
        scrollView.addSubview(rowsStepper!)
        //行计数器
        let rowStepperFrame = CGRect(x: collectionView.frame.maxY, y: 0, width: 50, height: 30)
        rowsStepper = UIStepper(frame: rowStepperFrame)
        rowsStepper?.minimumValue = 1
        rowsStepper?.maximumValue = 100
        rowsStepper?.value = Double(cols)
        rowsStepper?.stepValue = 1
        rowsStepper?.addTarget(self, action: #selector(stepperValueChanged(sender:)), for: .valueChanged)
        scrollView.addSubview(rowsStepper!)
        
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return rows+1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cols+1
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:TextFieldCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "TextFieldCollectionViewCell", for: indexPath) as! TextFieldCollectionViewCell
        cell.backgroundColor = UIColor.white
        let rowArray = dataArray[indexPath.section]
        cell.textField.textColor = UIColor.black
        if indexPath.section != 0 && indexPath.row != 0 {
             cell.textField.placeholder = "\(indexPath.section) -- \(indexPath.row)"
        }else {
            cell.textField.placeholder = rowArray[indexPath.row]
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
        cols = Int(sender.value)
        updateUI()
    }
    
    //MARK: - updateUI
    func updateUI()  {
        //修改列
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
            }
            
            
        }
        let frame = CGRect(x: 0, y: 0,
                           width: CGFloat(collectionCols)*(Constant.kCellWidth + Constant.kCellSpace),
                           height: CGFloat(collectionSections)*(Constant.kCellHight + Constant.kCellSpace))
        collectionView.frame = frame
        let stepperFrame = CGRect(x: collectionView.frame.maxX, y: 0, width: 50, height: 30)
        rowsStepper?.frame = stepperFrame
        scrollView.contentSize = CGSize(width: collectionView.frame.maxX + 160, height: collectionView.frame.maxY + 50)
        collectionView.reloadData()
        
    }


}

