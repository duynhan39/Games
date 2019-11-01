//
//  NewInfoCell.swift
//  Student Management System
//
//  Created by Nhan Cao on 10/12/19.
//  Copyright © 2019 Nhan Cao. All rights reserved.
//

import UIKit
@IBDesignable

class InfoCell: UITableViewCell {
    
    // MARK: Variables
    
    private var attributeNameLabel : UILabel = {
        let lbl = UILabel()
        lbl.textColor = .black
        lbl.font = UIFont.boldSystemFont(ofSize: 17)
        lbl.textAlignment = .left
        return lbl
    }()
    
    var attributeInputTextField : UITextField = {
        let lbl = UITextField()
        lbl.textColor = .black
        lbl.font = UIFont.systemFont(ofSize: 17)
        lbl.textAlignment = .left
        return lbl
    }()
    
    var viewMode = ObjectInfoView.ViewMode.edit {
        didSet {
            setNeedsLayout()
            setNeedsDisplay()
        }
    }
    
    var labelName = "" {
        didSet {
            attributeNameLabel.text = labelName
            attributeInputTextField.placeholder = placeHolderText
            attributeInputTextField.autocapitalizationType = autoCapStyle(of: labelName)
            attributeInputTextField.keyboardType = keyboardType(of: labelName)
        }
    }
    
    var placeHolderText : String {
        return convertPlaceHolderString(from: labelName)
    }
    
    // MARK: Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        addSubview(attributeNameLabel)
        labelName = "Attribute"
        
        let gap : CGFloat = 15
        let height: CGFloat = 17
        attributeNameLabel.anchor(top: topAnchor,
                                  left: leftAnchor,
                                  bottom:nil,
                                  right: rightAnchor,
                                  paddingTop: gap,
                                  paddingLeft: gap,
                                  paddingBottom: gap,
                                  paddingRight: gap,
                                  width: self.frame.width-2*gap,
                                  height: height,
                                  enableInsets: false)
        
        
        addSubview(attributeInputTextField)
        attributeInputTextField.anchor(top: attributeNameLabel.bottomAnchor,
                                       left: leftAnchor,
                                       bottom: bottomAnchor,
                                       right: rightAnchor,
                                       paddingTop: gap,
                                       paddingLeft: gap,
                                       paddingBottom: gap,
                                       paddingRight: gap,
                                       width: self.frame.width-2*gap,
                                       height: height*2,
                                       enableInsets: false)
        
        attributeInputTextField.autocorrectionType = .no
    }
    
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        // Initialization code
//    }
//
//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//        // Configure the view for the selected state
//    }
    
    // MARK: Draw
//    override func draw(_ rect: CGRect) {
//    }
    
}

// MARK: Extensions

extension InfoCell {
    
    private func autoCapStyle(of attribute: String) ->  UITextAutocapitalizationType {
        switch attribute {
        case "First name", "Last name", "Meeting days", "Location", "Home address", "Office address", "Campus address":
            return .words
        case "Time", "Department code":
            return .allCharacters
        case "Course name":
            return .sentences
        default:
            return .none
        }
    }
    
    private func keyboardType(of attribute: String) -> UIKeyboardType {
        switch attribute {
        case "Phone number":
            return .phonePad
        case "Email":
            return .emailAddress
        case "Student ID":
            return .namePhonePad
        default:
            return .default
        }
    }
    
    private func convertPlaceHolderString(from text: String) -> String {
        var actualValue = ""
        
        if viewMode == .view {return "N/A"}
        
        switch text {
        case "Time":
            actualValue = "8:00-8:50"
        case "Meeting days":
            actualValue = "M T W Th F Sa Su"
        case "Email":
            actualValue = "example@email.com"
        case "Phone number":
            actualValue = "XXX-XXX-XXXX"
        case "Student ID":
            actualValue = "7-digit number"
        default:
            actualValue = text
        }
        return actualValue
    }
}

extension UIView {
    func anchor (top: NSLayoutYAxisAnchor?,
                 left: NSLayoutXAxisAnchor?,
                 bottom: NSLayoutYAxisAnchor?,
                 right: NSLayoutXAxisAnchor?,
                 paddingTop: CGFloat,
                 paddingLeft: CGFloat,
                 paddingBottom: CGFloat,
                 paddingRight: CGFloat,
                 width: CGFloat,
                 height: CGFloat,
                 enableInsets: Bool) {
        
        var topInset = CGFloat(0)
        var bottomInset = CGFloat(0)
        
        if #available(iOS 11, *), enableInsets {
            let insets = self.safeAreaInsets
            topInset = insets.top
            bottomInset = insets.bottom
        }
        
        translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top {
            topAnchor.constraint(equalTo: top, constant: paddingTop+topInset).isActive = true
        }
        if let left = left {
            leftAnchor.constraint(equalTo: left, constant: paddingLeft).isActive = true
        }
        if let right = right {
            rightAnchor.constraint(equalTo: right, constant: -paddingRight).isActive = true
        }
        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: bottom, constant: -paddingBottom-bottomInset).isActive = true
        }
        if height != 0 {
            heightAnchor.constraint(equalToConstant: height).isActive = true
        }
        if width != 0 {
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }
    }
}
