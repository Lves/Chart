//
//  PieEditViewController.swift
//  Chart
//
//  Created by lixingle on 2017/12/4.
//  Copyright © 2017年 com.lvesli. All rights reserved.
//

import UIKit

public struct PieChartData{
    var index:Int = 0
    var name:String?
    var value:String?
}

class PieEditViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {

    @IBOutlet var footerView: UIView!
    @IBOutlet var btnAdd: UIButton!
    @IBOutlet weak var tableView: UITableView!
    var dataArray:[PieChartData] = []
    
    struct InnerConst {
        static let CellIdentifier = "TwoTextfieldsTableViewCell"
        static let CellHeight:CGFloat = 55.0
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "数据录入"
        
        tableView.separatorColor = ColorTheme.TableViewSeparatorColor
        tableView.register(UINib.init(nibName: InnerConst.CellIdentifier, bundle: Bundle.main), forCellReuseIdentifier: InnerConst.CellIdentifier)
        tableView.tableFooterView = footerView
        
        
        dataArray = [PieChartData(),PieChartData()]
        tableView.reloadData()
    }
    
    

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: InnerConst.CellIdentifier, for: indexPath) as! TwoTextfieldsTableViewCell
        cell.nameTextField.delegate = self
        cell.valueTextField.delegate = self
        var chartData = dataArray[indexPath.row]
        chartData.index = indexPath.row
        cell.pieChartData = chartData
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return InnerConst.CellHeight
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated:false)
        
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        return view
    }
    //MARK: - Action
    
    @IBAction func addNewLine(_ sender: Any) {

        dataArray.append(PieChartData())
        tableView.reloadData()
        let indexPath = IndexPath(row: dataArray.count-1, section: 0)
        tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
    }
    
    @IBAction func toPieChartView(_ sender: Any) {
        
        view.endEditing(true)
        let pieChartVc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PieChartViewController") as! PieChartViewController
        pieChartVc.dataArray = dataArray
        navigationController?.pushViewController(pieChartVc, animated: true)
        
    }
}

extension PieEditViewController: UITextFieldDelegate {
    public func textFieldDidEndEditing(_ textField: UITextField) {
        if let cell = textField.superview?.superview as? TwoTextfieldsTableViewCell ,let indexPath = tableView.indexPath(for: cell){
            var chartData = dataArray[indexPath.row]
            
            if textField == cell.nameTextField {
                chartData.name = textField.text ?? ""
            }else if textField == cell.valueTextField{
                chartData.value = textField.text ?? ""
            }
            dataArray[indexPath.row] = chartData
        }
    }
}
