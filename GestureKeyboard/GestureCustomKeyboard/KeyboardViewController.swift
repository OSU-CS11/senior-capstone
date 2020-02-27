//
//  KeyboardViewController.swift
//  GestureCustomKeyboard
//
//  Created by Changkuan Li on 2/10/20.
//  Copyright © 2020 ChangkuanLi. All rights reserved.
//

import UIKit
import SnapKit

class KeyboardViewController: UIInputViewController {

    var caseType: String = ""
    let keyboardViewHeight = 280
    
    let SCWidth = UIScreen.main.bounds.width
    @IBOutlet var nextKeyboardButton: UIButton!
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        
        // Add custom view sizing constraints here
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let heightConstraint = NSLayoutConstraint(item: self.view as Any, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 0.0, constant: CGFloat(keyboardViewHeight))
        self.view.addConstraint(heightConstraint)
        
        self.view.backgroundColor = .white
        
        caseType = "ABC"
        
        addNextKeyboardButton()
        keyboardView()
        
    }
    
    func addNextKeyboardButton() {
        // Perform custom UI setup here
        self.nextKeyboardButton = UIButton(type: .system)
        
        self.nextKeyboardButton.setTitle(NSLocalizedString("", comment: "Title for 'Next Keyboard' button"), for: [])
        self.nextKeyboardButton.sizeToFit()
        self.nextKeyboardButton.translatesAutoresizingMaskIntoConstraints = false
        
        self.nextKeyboardButton.addTarget(self, action: #selector(handleInputModeList(from:with:)), for: .allTouchEvents)
        
        self.view.addSubview(self.nextKeyboardButton)
        
        self.nextKeyboardButton.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        self.nextKeyboardButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
    }
    
    
    func keyboardView() {
        
        let topView = UIView()
        topView.backgroundColor = .lightGray
        view.addSubview(topView)
        topView.snp.makeConstraints { (make) in
            make.top.equalTo(view.snp.top)
            make.left.equalTo(view.snp.left)
            make.right.equalTo(view.snp.right)
            make.height.equalTo(50)
        }
        
        //Caps
        let caseButton: UIButton = UIButton()
        caseButton.setImage(UIImage(named: "cap.png"), for: .normal)
        caseButton.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        caseButton.addTarget(self, action: #selector(caseButtonTouch), for: .touchUpInside)
        topView.addSubview(caseButton)
        caseButton.snp.makeConstraints { (make) in
            make.top.equalTo(topView.snp.top)
            make.left.equalTo(topView.snp.left)
            make.width.equalTo(50)
            make.height.equalTo(50)
        }
        
        //Delete
        let delButton: UIButton = UIButton()
        delButton.setImage(UIImage(named: "delete.png"), for: .normal)
        delButton.imageEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        delButton.addTarget(self, action: #selector(delButtonTouch), for: .touchUpInside)
        topView.addSubview(delButton)
        delButton.snp.makeConstraints { (make) in
            make.top.equalTo(topView.snp.top)
            make.right.equalTo(self.view.snp.right)
            make.width.equalTo(50)
            make.height.equalTo(50)
        }
        
        let bottomView = UIView()
        self.view.addSubview(bottomView)
        bottomView.snp.makeConstraints { (make) in
            make.bottom.equalTo(view.snp.bottom)
            make.left.equalTo(view.snp.left)
            make.right.equalTo(view.snp.right)
            make.height.equalTo(50)
        }
        
        //Change Keyboard
        let chgButton: UIButton = UIButton()
        chgButton.setImage(UIImage(named: "globe.png"), for: .normal)
        chgButton.imageEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        chgButton.addTarget(self, action: #selector(chgButtonTouch), for: .touchUpInside)
        bottomView.addSubview(chgButton)
        chgButton.snp.makeConstraints { (make) in
            make.centerY.equalTo(bottomView)
            make.left.equalTo(bottomView.snp.left).offset(10)
            make.width.equalTo(50)
            make.height.equalTo(50)
        }
        
        //Space
        let spaceButton: UIButton = UIButton()
//        spaceButton.setImage(UIImage(named: "space.png"), for: .normal)
//        spaceButton.imageEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        spaceButton.setTitle("Space", for: .normal)
        spaceButton.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        spaceButton.layer.cornerRadius = 5
        spaceButton.layer.masksToBounds = true
        spaceButton.layer.borderWidth = 4
        spaceButton.layer.borderColor = UIColor.black.cgColor
        spaceButton.setTitleColor(.black, for: .normal)
        spaceButton.addTarget(self, action: #selector(spaceButtonTouch), for: .touchUpInside)
        bottomView.addSubview(spaceButton)
        spaceButton.snp.makeConstraints { (make) in
            make.centerY.equalTo(bottomView)
            make.left.equalTo(bottomView.snp.left).offset(70)
            make.right.equalTo(bottomView.snp.right).offset(-70)
            make.height.equalTo(40)
        }
        
        let keyViewFirst = UIView()
        keyViewFirst.tag = 2000
        view.addSubview(keyViewFirst)
        keyViewFirst.snp.makeConstraints { (make) in
            make.top.equalTo(topView.snp.bottom).offset(10)
            make.bottom.equalTo(bottomView.snp.top).offset(-10)
            make.left.equalTo(view.snp.left)
            make.right.equalTo(view.snp.right)
        }
        let buttonTitles: Array<Any>
        if caseType == "abc" {
            buttonTitles = ["a", "b", "c"]
        }else{
            buttonTitles = ["A", "B", "C"]
        }
        let keyFirstWIth = SCWidth / 3
        for i in 0..<buttonTitles.count {
            let keyX: CGFloat = CGFloat(i) * keyFirstWIth
            let keyButton:UIButton = UIButton(frame: CGRect(x: keyX, y: 0, width: keyFirstWIth, height: CGFloat(keyboardViewHeight)-120 ))
            keyButton.titleLabel?.font = UIFont.systemFont(ofSize: 30)
            keyButton.setBackgroundImage(UIImage(named:"frame.png"), for: .normal)
            keyViewFirst.addSubview(keyButton)
            keyButton.setTitleColor(.black, for: .normal)
            keyButton.setTitle((buttonTitles[i] as! String), for: .normal)
            keyButton.addTarget(self, action: #selector(firstRowButtonTouch), for: .touchUpInside)
        }
        
    }
    
    @objc func firstRowButtonTouch(sender: UIButton) {
        let title = sender.title(for: .normal)
        let proxy = textDocumentProxy as UITextDocumentProxy
        proxy.insertText(title!)
    }
    
    @objc func caseButtonTouch(sender: UIButton) {
        if caseType == "ABC" {
            caseType = "abc"
        }else{
            caseType = "ABC"
        }
        let subViews = self.view.subviews
        for subview in subViews{
            if subview.tag == 2000 {
             subview.removeFromSuperview()
            }
        }
        keyboardView()
    }
    
    @objc func spaceButtonTouch(sender: UIButton) {
        let proxy = textDocumentProxy as UITextDocumentProxy
        proxy.insertText(" ")
    }
    
    @objc func chgButtonTouch(sender: UIButton) {
        self.advanceToNextInputMode()
    }
    
    @objc func delButtonTouch(sender: UIButton) {
        let proxy = textDocumentProxy as UITextDocumentProxy
        proxy.deleteBackward()
    }
    
    override func viewWillLayoutSubviews() {
        self.nextKeyboardButton.isHidden = !self.needsInputModeSwitchKey
        super.viewWillLayoutSubviews()
    }
    
    override func textWillChange(_ textInput: UITextInput?) {
        // The app is about to change the document's contents. Perform any preparation here.
    }
    
    override func textDidChange(_ textInput: UITextInput?) {
        // The app has just changed the document's contents, the document context has been updated.
        
        var textColor: UIColor
        let proxy = self.textDocumentProxy
        if proxy.keyboardAppearance == UIKeyboardAppearance.dark {
            textColor = UIColor.white
        } else {
            textColor = UIColor.black
        }
        self.nextKeyboardButton.setTitleColor(textColor, for: [])
    }

}
