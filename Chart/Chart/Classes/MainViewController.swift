//
//  MainViewController.swift
//  Chart
//
//  Created by lixingle on 2017/12/3.
//  Copyright © 2017年 com.lvesli. All rights reserved.
//

import UIKit

struct ColorTheme {
    static let NavigationBarTitle = UIColor.white
    static let NavigationBar = UIColor(hex6: 0x2f3549)
    static let ViewBackground = UIColor(hex6: 0xf3f6fc)
    static let LineGray = UIColor.white.withAlphaComponent(0.15)
    static let LineOrange = UIColor(hex6: 0xfd734c)
    static let TextFieldCursor = UIColor(hex6: 0xfd734c)
}

class MainViewController: UIViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        title = "首页"

        var font = UIFont.boldSystemFont(ofSize: 17)
        if #available(iOS 8.2, *) {
            font = UIFont.systemFont(ofSize: 17, weight: UIFont.Weight.medium)
        }
        navigationController?.navigationBar.titleTextAttributes =
            [NSAttributedStringKey.foregroundColor: UIColor(hex6:0xfafafa),
             NSAttributedStringKey.font: font]
       
        
    }


}

public extension UIImage {
    public convenience init?(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) {
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        color.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        guard let cgImage = image?.cgImage else { return nil }
        self.init(cgImage: cgImage)
    }
}

