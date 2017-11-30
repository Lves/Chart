//
//  ViewController.swift
//  Chart
//
//  Created by lixingle on 2017/11/30.
//  Copyright © 2017年 com.lvesli. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var scrollView: UIScrollView!
    var collectionView: UICollectionView!
    var dataArray:[String] = []
    var cols:Int = 5
    var rows:Int = 3
    
    
    struct Constant {
        static let kCellWidth:CGFloat = 80
        static let kCellHight:CGFloat = 45
        static let kCellSpace:CGFloat = 0.5
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        dataArray = Array(repeating: "", count: Int(cols*rows))
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = Constant.kCellSpace
        layout.minimumInteritemSpacing = Constant.kCellSpace

        let frame = CGRect(x: 0, y: 0,
                           width: CGFloat(rows)*(Constant.kCellWidth + Constant.kCellSpace),
                           height: CGFloat(cols)*(Constant.kCellHight + Constant.kCellSpace))
        
        collectionView = UICollectionView(frame: frame, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.gray
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UINib(nibName: "TextFieldCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "TextFieldCollectionViewCell")
        scrollView.contentSize = CGSize(width: collectionView.frame.size.width, height: collectionView.frame.size.height)
        scrollView.addSubview(collectionView)
        for index in 1..<rows {
            dataArray[index] = "第\(index)列"
        }
        for index in 1..<cols {
            let nextIndex = index*rows
            dataArray[nextIndex] = "第\(index)行"
        }
        dataArray[0] = "行\\列"
        collectionView.reloadData()
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataArray.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:TextFieldCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "TextFieldCollectionViewCell", for: indexPath) as! TextFieldCollectionViewCell
        cell.textField.placeholder = "\(indexPath.row)"
        cell.backgroundColor = UIColor.white
        let str = dataArray[indexPath.row]

        if indexPath.row == 0 { //第一个
            cell.textField.isUserInteractionEnabled = false
            cell.textField.text = str
        }else  if str.count > 0 { //行或者列
            cell.textField.text = str
            cell.textField.placeholder = str
            cell.textField.textColor = UIColor.black
        }else{
            let col = indexPath.row % rows
            let row = indexPath.row / rows
            cell.textField.placeholder = " \(row) - \(col)"
            cell.textField.textColor = UIColor.gray
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        return CGSize(width: Constant.kCellWidth, height: Constant.kCellHight)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }



}

