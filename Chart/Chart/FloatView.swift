//
//  FloatView.swift
//  Chart
//
//  Created by lixingle on 2017/12/1.
//  Copyright © 2017年 com.lvesli. All rights reserved.
//

import UIKit

protocol FloatViewDelegate: class  {
    func floatViewMoveEnded(floatView:FloatView ,endPoint:CGPoint)
}

class FloatView: UIView {
    var startPoint:CGPoint = CGPoint.zero
    open weak var delegate:FloatViewDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        isUserInteractionEnabled = true
        backgroundColor = UIColor.purple
        layer.cornerRadius = frame.size.width/2
        layer.masksToBounds = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if self.point(inside: point, with: event){
            return self
        }
        return nil
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        startPoint = (touches.first?.location(in: self))!
//        self.superview?.bringSubview(toFront: self)
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        //计算位移=当前位置-起始位置
        let point = touches.first?.location(in: self)
        let dx = (point?.x ?? startPoint.x) - startPoint.x
        let dy = (point?.y ?? startPoint.y) - startPoint.y
        //计算移动后的view中心点
        var newcenter = CGPoint(x: self.center.x + dx, y: self.center.y + dy)
//        /* 限制用户不可将视图托出屏幕 */
//        let halfx = self.bounds.midX
//        //x坐标左边界
//        newcenter.x = max(halfx, newcenter.x)
//        //x坐标右边界
//        newcenter.x = min((self.superview?.bounds.size.width)! - halfx, newcenter.x);
//        //y坐标同理
//        let halfy = self.bounds.midY;
//        newcenter.y = max(halfy, newcenter.y);
//        newcenter.y = min((self.superview?.bounds.size.height)! - halfy, newcenter.y);
        //移动view
        self.center = newcenter;
        print("touchesMoved ---- \(newcenter)")
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.delegate?.floatViewMoveEnded(floatView: self, endPoint: self.center)
    }
}
