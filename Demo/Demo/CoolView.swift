//
//  CoolView.swift
//  Demo
//
//  Created by williamxie on 2023/7/31.
//

import UIKit

var lz_keyWindowOne = "lz_keyWindowOne"
var lz_maskViewOne = "lz_maskViewOne"
var lz_containerViewOne = "lz_containerViewOne"
var containerViewWidth : CGFloat = 270
var containerViewHight : CGFloat = 134
let AnimateDuration = 0.35;

extension UIView {
    /// 这个方法只是用来获取单例KeyWindow
    private var lz_keyWindow : UIView! {
        get{
            /// 这个地方就是利用运行时来获取KeyWidow
            var keyWindow = objc_getAssociatedObject(self, &lz_keyWindowOne) as? UIView
            if keyWindow == nil {
                // 如果没有就获取KeyWindow
                keyWindow = UIApplication.shared.keyWindow
            }
            return keyWindow!
        }
    }
    /// 这个是我们创建遮罩的视图
    private var lz_maskView : UIView! {
        get{
            /// 这个地方就是利用运行时来获取遮罩视图（第一次肯定没有）需要创建
            var mask = objc_getAssociatedObject(self, &lz_maskViewOne) as? UIView
            if mask == nil {
                // 创建遮罩视图
//                mask = UIView(frame: UIScreen.main.bounds)
                mask = UIView(frame: CGRect(x: 0, y: 174, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height - CGFloat(containerViewHight)))
                mask!.backgroundColor = UIColor(white: 0, alpha: 0.3)
                mask!.isUserInteractionEnabled = true
                // 在遮罩层上添加点击手势
                let tap = UITapGestureRecognizer(target: self, action: #selector(lz_cancelAction))
                mask!.addGestureRecognizer(tap)
                /// 这个地方就是利用运行时来存储遮罩视图 那上边下一次取的时候就有值了
                objc_setAssociatedObject(self, &lz_maskViewOne, mask, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
            return mask!
        }
    }

    /// 这个是我们创建容器视图
    private var lz_containerView : UIView! {
        get{
            /// 这个地方就是利用运行时来获取容器视图 第一次肯定没有）需要创建
            var container = objc_getAssociatedObject(self, &lz_containerViewOne) as? UIView
            if container == nil {
                // 创建容器视图
                container = UIView()
                container!.backgroundColor = UIColor.white
                container!.backgroundColor = UIColor.red
                /// 这里是把你的筛选视图添加到容器视图上
                container!.addSubview(self)

//                self.frame =  CGRect(x: 0, y: 0, width: containerViewWidth, height: Int(UIScreen.main.bounds.size.height))
//                container!.frame.size = CGSize(width: CGFloat(containerViewWidth), height: UIScreen.main.bounds.size.height)
                self.frame =  CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 134)
                container!.frame.size = CGSize(width: UIScreen.main.bounds.size.width, height: containerViewHight)




                /// 这个地方就是利用运行时来存储容器视图 那上边下一次取的时候就有值了
                objc_setAssociatedObject(self, &lz_containerViewOne, container, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
            return container!
        }
    }

    /// 这里是暴露在外的方法（只要调用此方法就能显示）
    open func lz_showInWindowWithRight(){
        /// 这里需要注意的是遮罩视图和容器视图一定放keyWindow 上的要不会有bug
        self.lz_keyWindow.addSubview(self.lz_maskView)
        self.lz_keyWindow.addSubview(self.lz_containerView)
        self.lz_maskView.alpha = 0.0
        self.lz_containerView.frame.origin.x = UIScreen.main.bounds.size.width
        /// 这里做左滑的动画
        UIView.animate(withDuration: AnimateDuration) {
            self.lz_maskView.alpha = 1
            self.lz_containerView.frame.origin.x = UIScreen.main.bounds.size.width - CGFloat(containerViewWidth)
        }
    }
    /// 这里是暴露在外的方法（只要调用此方法就能显示）
    open func lz_showInWindowWithTop(){
        /// 这里需要注意的是遮罩视图和容器视图一定放keyWindow 上的要不会有bug
        self.lz_keyWindow.addSubview(self.lz_maskView)
        self.lz_keyWindow.addSubview(self.lz_containerView)
        self.lz_maskView.alpha = 0.0
        self.lz_maskView.alpha = 1


//        self.lz_containerView.frame.origin.x = UIScreen.main.bounds.size.width
        /// 这里做左滑的动画
        UIView.animate(withDuration: AnimateDuration) {

        }
    }


    /// 遮罩视图上的点击事件
    @objc private func lz_cancelAction(){
        lz_dismissFromWindow()
    }
    /// 隐藏筛选视图
    func lz_dismissFromWindow(){

        self.lz_maskView.removeFromSuperview()
        self.lz_containerView.removeFromSuperview()

//        UIView.animate(withDuration: AnimateDuration, animations: {
//            self.lz_maskView.alpha = 0.0
//            self.lz_containerView.frame.origin.x = UIScreen.main.bounds.size.width
//        }) { (finished) in
//
//        }
    }
}
