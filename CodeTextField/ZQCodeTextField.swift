//
//  ZQCodeTextField.swift
//  ZQCodeTextField
//
//  Created by zhangqq on 2018/3/2.
//  Copyright © 2018年 zhangqq. All rights reserved.
//


let screenWidth = UIScreen.main.bounds.width
let screenHeight = UIScreen.main.bounds.height

func RGBColor(r:CGFloat,g:CGFloat,b:CGFloat, a:CGFloat) -> UIColor {
    return UIColor.init(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: a)
}

func HEXColor(h:Int) -> UIColor {
    return RGBColor(r: CGFloat(((h)>>16) & 0xFF), g:   CGFloat(((h)>>8) & 0xFF), b:  CGFloat((h) & 0xFF),a:1.0)
}

func HEXColorA(h:Int,a:CGFloat) -> UIColor {
    return RGBColor(r: CGFloat(((h)>>16) & 0xFF), g:CGFloat(((h)>>8) & 0xFF), b:  CGFloat((h) & 0xFF),a:a)
}

import UIKit

class ZQCodeTextField: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
        self.exchangeMethod()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //验证码、密码获取
    public  var code:String? {
        get{
            var codeString = ""
            for i in 1...codeCount {
                let item = self.viewWithTag(i) as! UILabel
                if let text = item.text {
                    codeString += text
                }
            }
            return codeString
        }
    }
    
    private var codeTextField:UITextField?
    private let codeCount = 6
    
    private func commonInit(){
        
        let space:CGFloat! = 15.0
        let itemWidth = (self.frame.size.width - space*CGFloat(codeCount - 1))/CGFloat(codeCount)
        let itemHeight = self.frame.size.height
        
        for i in 1...codeCount {
            print(i)
            let item = UILabel()
            let x = CGFloat(i - 1) * (itemWidth + space)
            item.frame = CGRect.init(x: x, y: 0, width: itemWidth, height: itemHeight-1)
            item.textAlignment = .center
            item.backgroundColor = UIColor.clear
            item.font = UIFont.systemFont(ofSize: 13)
            item.tag = i
            item.text = ""
            self.addSubview(item)
            
            let line = UIView()
            line.backgroundColor = HEXColor(h: 0xdfdfdf)
            line.frame = CGRect.init(x: x, y: itemHeight - 1, width: itemWidth, height: 1)
            self.addSubview(line)
        }
        
        let item = self.viewWithTag(1)
        
        codeTextField = UITextField()
        codeTextField?.frame = (item?.frame)!
        codeTextField?.textAlignment = .center
        codeTextField?.delegate = self
        codeTextField?.keyboardType = .numberPad
        self.addSubview(codeTextField!)
    }
    //获取最后一个有code的item
   private func getHaveCodeItem() -> UILabel {
        for i in (1...codeCount).reversed() {
            let item = self.viewWithTag(i) as! UILabel
            if let text = item.text {
                if text.isEmpty == false {
                    return item
                }
            }
        }
        return self.viewWithTag(1) as! UILabel
    }
    
    //获取最后一个空item
   private func getEmptyCodeItem() -> UILabel {
        for i in 1...codeCount {
            let item = self.viewWithTag(i) as! UILabel
            if let text = item.text {
                if text.isEmpty {
                    return item
                }
            }
        }
        return self.viewWithTag(codeCount) as! UILabel
    }
    
    override func becomeFirstResponder() -> Bool {
        superview?.becomeFirstResponder()
        return (self.codeTextField?.becomeFirstResponder())!
    }
}

//输入
extension ZQCodeTextField:UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string.isEmpty == false {
            let item = self.getEmptyCodeItem()
            if item.text?.isEmpty == false {
                return false
            }
            
            item.text = string
            if item.tag != codeCount {
                let nextItem = self.viewWithTag(item.tag + 1) as! UILabel
                codeTextField?.frame = nextItem.frame
            }
        }
        return false
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
         return false
    }
}

//删除
extension ZQCodeTextField {
    func exchangeMethod() {
        let originaMethod = class_getInstanceMethod(UITextField.classForCoder(), NSSelectorFromString("deleteBackward"))
        let swizzeMethod = class_getInstanceMethod(object_getClass(self), #selector(zq_DeleteBackward))
        method_exchangeImplementations(originaMethod!, swizzeMethod!)
    }
    
    @objc func zq_DeleteBackward() {
        
        if  let codeView:ZQCodeTextField = self.superview as? ZQCodeTextField {
            let item = codeView.getHaveCodeItem()
            if (item.text?.isEmpty)! == false {
                item.text = ""
                if item.tag != codeView.codeCount {
                    let nextItem = codeView.viewWithTag(item.tag) as! UILabel
                    self.frame = nextItem.frame
                }
            }
        }
    }
}










