//
//  TwoTextfieldsTableViewCell.swift
//  Chart
//
//  Created by lixingle on 2017/12/4.
//  Copyright © 2017年 com.lvesli. All rights reserved.
//

import UIKit

class TwoTextfieldsTableViewCell: UITableViewCell {

    @IBOutlet weak var lblIndex: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var valueTextField: UITextField!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    var pieChartData:PieChartData?{
        didSet{
            lblIndex.text = "\(pieChartData?.index ?? 0)"
            nameTextField.text = pieChartData?.name ?? ""
            valueTextField.text = pieChartData?.value ?? ""
        }
    }
    
}
