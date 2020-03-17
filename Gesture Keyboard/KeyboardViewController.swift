//
//  KeyboardViewController.swift
//  GestureCustomKeyboard
//
//  Created by Changkuan Li on 2/10/20.
//  Copyright © 2020 ChangkuanLi. All rights reserved.
//

import UIKit
import CoreML
import CoreMotion

class KeyboardViewController: UIInputViewController {
    
    var upper: Bool = false;
    
    // MARK:- Properties
    
    private var gestureAI = GestureAlphabetProcessor()
    private let queue = OperationQueue.init()
    private let motionManager = CMMotionManager()
    private lazy var timer: Timer = {
        Timer.scheduledTimer(timeInterval: 1.0, target: self,
                             selector: #selector(self.updateTimer(tm:)), userInfo: nil, repeats: true)
    }()
    let userDefaults = UserDefaults.standard
    
    private let timeMax: Int = 4
    private var cntTimer: Int = 0
    private let inputDim: Int = 3
    private let lengthMax: Int = 30
    private var sequenceTargetX: [Double] = []
    private var sequenceTargetY: [Double] = []
    private var sequenceTargetZ: [Double] = []
    


    // MARK:- Outlets
    @IBOutlet var keyboardView: UIView!
    let SCWidth = UIScreen.main.bounds.width
    @IBOutlet var nextKeyboardButton: UIButton!
    @IBOutlet weak var mainButton: UIButton!
    @IBOutlet weak var spaceBar: UIButton!
    @IBOutlet weak var enterButton: UIButton!
    @IBOutlet weak var capsButton: UIButton!
    @IBOutlet weak var delButton: UIButton!
    
    
    var pickerData: [String] = ["A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"];
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        
        // Add custom view sizing constraints here
    }
    
    // MARK:- UIViewControllers
    override func viewDidLoad() {
        super.viewDidLoad()
        loadInterface();
        //addNextKeyboardButton()
    }
    
    func loadInterface() {
        let keyboardNib = UINib(nibName: "KeyboardView", bundle: nil)
        keyboardView = keyboardNib.instantiate(withOwner: self, options: nil) [0] as! UIView
        keyboardView.frame.size = view.frame.size
        view.addSubview(keyboardView)
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
    
    @IBAction func mainTouchUp(_ sender: Any) {
        motionManager.stopAccelerometerUpdates()

        timer.invalidate()
        cntTimer = 0
        
        let cnt = self.sequenceTargetX.count
        if cnt >= inputDim {
            cntTimer = 0
            return
        }
        
        // Pay attention to input dimension for RNN
        for _ in cnt..<lengthMax*inputDim {
            self.sequenceTargetX.append(0.0)
            self.sequenceTargetY.append(0.0)
            self.sequenceTargetZ.append(0.0)
        }

        let output = predict(self.sequenceTargetX,self.sequenceTargetY,self.sequenceTargetZ)
        
        //let title = sender.title(for: .normal)
        let proxy = textDocumentProxy as UITextDocumentProxy
        proxy.insertText(output.label)
        
        
    }
    
    @IBAction func firstRowButtonTouchDown(sender: UIButton) {
        
        self.sequenceTargetX = []
        self.sequenceTargetY = []
        self.sequenceTargetZ = []
        
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.updateTimer(tm:)), userInfo: nil, repeats: true)
        timer.fire()
        
        motionManager.startAccelerometerUpdates(to: queue, withHandler: {
            (accelerometerData, error) in
            if let e = error {
                fatalError(e.localizedDescription)
            }
            guard let data = accelerometerData else { return }
            self.sequenceTargetX.append(data.acceleration.x)
            self.sequenceTargetY.append(data.acceleration.y)
            self.sequenceTargetZ.append(data.acceleration.z)
        })
    }
    
    @IBAction func caseButtonTouch(_ sender: Any) {
        if (upper) {
            upper = false;
            capsButton.setImage(UIImage(systemName: "capslock"), for: .normal)
        } else {
            upper = true;
            capsButton.setImage(UIImage(systemName: "capslock.fill"), for: .normal)
        }
    }
    
    @IBAction func spaceButtonTouch(_ sender: Any) {
        let proxy = textDocumentProxy as UITextDocumentProxy
        proxy.insertText(" ")
    }
    
    @IBAction func chgButtonTouch(_ sender: Any) {
        self.advanceToNextInputMode()
    }
    
    @IBAction func delButtonTouch(_ sender: Any) {
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
    
    
    // MARK:- Utils
    
    @objc private func updateTimer(tm: Timer) {
        if cntTimer >= timeMax {
//TODO: change button color
            timer.invalidate()
            cntTimer = 0
            return
        }
        cntTimer += 1
    }

    /// Convert double array type into MLMultiArray
    ///
    /// - Parameters:
    /// - arr: double array
    /// - Returns: MLMultiArray
    private func toMLMultiArray(_ arr: [Double]) -> MLMultiArray {
        guard let sequence = try? MLMultiArray(shape:[30], dataType:MLMultiArrayDataType.double) else {
            fatalError("Unexpected runtime error. MLMultiArray")
        }
        let size = Int(truncating: sequence.shape[0])
        for i in 0..<size {
            sequence[i] = NSNumber(floatLiteral: arr[i])
        }
        return sequence
    }
    
    /// Predict class label
    ///
    /// - Parameters:
    /// - arr: Sequence
    /// - Returns: Likelihood
    private func predict(_ arrX: [Double], _ arrY: [Double], _ arrZ: [Double]) -> GestureAlphabetProcessorOutput {
        guard let output = try? gestureAI.prediction(input:
            GestureAlphabetProcessorInput(accelerometerAccelerationX_G_: toMLMultiArray(arrX),
                                          accelerometerAccelerationY_G_: toMLMultiArray(arrY),
                                          accelerometerAccelerationZ_G_: toMLMultiArray(arrZ)), options: MLPredictionOptions()) else {
                fatalError("Unexpected runtime error.")
        }
        return output
    }

}

