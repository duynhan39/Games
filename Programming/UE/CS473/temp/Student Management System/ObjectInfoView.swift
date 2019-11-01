//
//  NewObjectView.swift
//  Student Management System
//
//  Created by Nhan Cao on 10/13/19.
//  Copyright © 2019 Nhan Cao. All rights reserved.
//

import UIKit
@IBDesignable

class ObjectInfoView: UIView, UITableViewDataSource  {
    
    // MARK: - Variables
    private var tableView = UITableView()
    var profileImageView = UIImageView()
    private var viewLabel = UILabel()
    private var segmentedSwitch = UISegmentedControl(items: ["Info", "Courses"])
    private var addRelationButton = UIButton()
    
    let defaultSystemImage = "person.circle.fill"
    var didSetImage = false
    
    var parent :GenericInfoViewController? = nil
    
    var objectData = [String:Any]() {
        didSet {
            updateProperties()
            showProfilePicture()
        }
    }
    
    var tableContent : [Any] {
        switch viewTarget {
        case .info:
            return attributeNames
        case .relation:
            return objectData[DataModel.relation(of: objectType)] as? [Any] ?? [Any]()
        }
    }
    
    private var attributeNames : [String] {
        get {
            return ObjectInfoView.AttributeNames[self.objectType.rawValue] ?? []
        }
    }
    
    var objectType = DataModel.ObjectType.student {
        didSet {
            refresh()
        }
    }
    
    var viewLabelText : String {
        get {
            var text = ""
            switch viewMode {
            case .add:
                text = "Create new \(self.objectType.description.lowercased())"
            case .edit, .view:
                text = "\(self.objectType)"
            }
            return text
        }
    }
    
    var viewMode = ObjectInfoView.ViewMode.add {
        didSet {
            updateProperties()
        }
    }
    
    var viewTarget = ObjectInfoView.ViewTarget.info {
        didSet {
            tableView.reloadData()
            switch viewTarget {
            case .info:
                addRelationButton.isHidden = true
            case .relation:
                addRelationButton.isHidden = false
            }
        }
    }
    
    var isEditable : Bool {
        switch viewMode {
        case .view:
            return false
        case .add, .edit:
            return true
        }
    }
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        objectType = DataModel.ObjectType.student
        
        addSubview(profileImageView)
        addSubview(tableView)
        addSubview(viewLabel)
        addSubview(segmentedSwitch)
        addSubview(addRelationButton)
        
        let tapGuesture = UITapGestureRecognizer(target: self, action: #selector(pickImage(_:)))
        profileImageView.addGestureRecognizer(tapGuesture)
        profileImageView.image = UIImage(systemName: defaultSystemImage)
        
        tableView.dataSource = self
        tableView.register(InfoCell.self, forCellReuseIdentifier: "infoCell")
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "ralationCell")
        
        tableView.bounces = false
        tableView.allowsSelection =  false
        //        tableView.isEditing = true
        
        viewLabel.textAlignment = .center
        
        segmentedSwitch.selectedSegmentIndex = 0
        segmentedSwitch.addTarget(self, action: #selector(changeTargetView(_:)), for: .valueChanged)
        
        addRelationButton.setImage(UIImage(systemName: "plus.circle"), for: .normal)
        addRelationButton.setImage(UIImage(systemName: "plus.circle.fill"), for: .highlighted)
        addRelationButton.isHidden = true
        addRelationButton.addTarget(self, action: #selector(pickObjects(_:)), for: .touchUpInside)
        
    }
    
    // MARK: Functional features
    
    @objc private func pickImage(_ sender: Any) {
        if parent != nil {
            parent?.showImagePickerOptions()
        }
    }
    
    @objc private func changeTargetView(_ sender: Any) {
        viewTarget = ObjectInfoView.ViewTarget(rawValue: segmentedSwitch.selectedSegmentIndex) ?? .info
    }
    
    @objc private func pickObjects(_ sender: Any) {
        var targetObjectType : DataModel.ObjectType
        switch objectType {
        case .student, .professor:
            targetObjectType = .course
        case .course:
            targetObjectType = .student
        }
        
        parent?.presentObjectPicker(with: targetObjectType)
    }
    
    // MARK: - Retrieve Data
    func getInputedData() -> [String:Any] {
        let attributeIds : [String:String] = ObjectInfoView.AttributeDecodedValue[self.objectType.rawValue] ?? ["":""]
        var data = [String:Any]()
        for i in 0..<attributeNames.count {
            let attName = attributeNames[i]
            let indexPath = IndexPath(row: i, section: 0)
            if let cell = tableView.cellForRow(at: indexPath) as? InfoCell {
                let attVal : String = cell.attributeInputTextField.text ?? ""
                data[attributeIds[attName] ?? "None"] = attVal
            }
        }
        
        if didSetImage {
            data["photo"] = profileImageView.image?.pngData()
        }
        
        objectData = data
        return data
    }
    
    
    // MARK: - Display
    func refresh() {
        setNeedsLayout()
        setNeedsDisplay()
        updateProperties()
    }
    
    func showProfilePicture() {
        if viewMode != .add {
            if let data = objectData["photo"] as? NSData {
                var image = UIImage(data: data as Data)
                if image == nil {
                    didSetImage = false
                    image = UIImage(systemName: defaultSystemImage)
                }
                profileImageView.image = image
            }
        }
    }
    
    private func updateProperties() {
        tableView.reloadData()
//        tableView.isUserInteractionEnabled = isEditable
        profileImageView.isUserInteractionEnabled = isEditable
        
        if viewMode == .view {
            segmentedSwitch.isHidden = false
        } else {
            segmentedSwitch.isHidden = true
        }
        
        switch objectType {
        case .student, .professor:
            segmentedSwitch.setTitle("Courses", forSegmentAt: 1)
        case .course:
            segmentedSwitch.setTitle("People", forSegmentAt: 1)
        }
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        setNeedsLayout()
        setNeedsDisplay()
    }
    
    override func draw(_ rect: CGRect) {
        clearsContextBeforeDrawing = true
        tableView.separatorStyle = .none
        
        let displayGap : CGFloat = 15
        var currentAvaiY : CGFloat = displayGap
        
        // MARK: Name label
        
        let labelFontSize : CGFloat = 20
        let labelFrame = CGRect(x: 0, y: currentAvaiY, width: self.frame.width, height: labelFontSize)
        viewLabel.frame = labelFrame
        viewLabel.font = UIFont.boldSystemFont(ofSize: labelFontSize)
        
        currentAvaiY = viewLabel.frame.maxY + displayGap
        
        viewLabel.text = viewLabelText
        
        // MARK: Profile picture
        
        if objectType != .course {
            let pictureEdge = min(self.frame.width/3, self.frame.height/5)
            let profilePicFrame = CGRect(x: (self.frame.width - pictureEdge)*0.5,
                                         y: currentAvaiY,
                                         width: pictureEdge,
                                         height: pictureEdge)
            
            profileImageView.frame = profilePicFrame
            profileImageView.layer.cornerRadius = pictureEdge*0.5
            profileImageView.clipsToBounds = true
            
            profileImageView.tintColor = UIColor.black
            
            currentAvaiY = profilePicFrame.maxY + displayGap
        }
        
        // MARK: Segmented Control
        
        let segmentHeight : CGFloat = segmentedSwitch.frame.height
        segmentedSwitch.center = CGPoint(x: self.frame.width/2, y: currentAvaiY+segmentHeight/2)
        
        // MARK: Add relation button
        
        addRelationButton.frame = CGRect(x: self.frame.width - segmentHeight, y: currentAvaiY, width: segmentHeight, height: segmentHeight)
        //         = addRelaButtonFrame
        
        if viewMode == .view || viewMode == .edit {
            currentAvaiY = segmentedSwitch.frame.maxY + displayGap
        }
        
        // MARK: Attribute table
        let tableHeight = self.frame.height - currentAvaiY
        let tableFrame = CGRect(x: 0,
                                y: currentAvaiY + displayGap,
                                width: self.frame.width,
                                height: tableHeight)
        
        tableView.frame = tableFrame
        
        let indexPath = IndexPath(row: 0, section: 0)
        if tableView.numberOfRows(inSection: 0) > 0 {
            tableView.scrollToRow(at: indexPath, at: .top, animated: false)
        }
    }
    
    // MARK: - Table View
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(tableContent.count)
        return tableContent.count
    }
    
    // MARK: Cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch viewTarget {
        case .info:
            return setUpAttributeCell(at: indexPath)
        case .relation:
            return setUpRelationCell(at: indexPath)
        }
    }
    
    private func setUpAttributeCell(at indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "infoCell", for: indexPath) as! InfoCell
        let attName : String = attributeNames[indexPath.row]
        cell.labelName = attName
        cell.viewMode = viewMode
        
        cell.isUserInteractionEnabled = isEditable
        
        var textFieldContent : String
        switch viewMode {
        case .edit, .view:
            let keyDict = ObjectInfoView.AttributeDecodedValue[objectType.description]
            textFieldContent = (objectData[keyDict?[attName] ?? ""] as? String) ?? ""
        default:
            textFieldContent = ""
        }
        cell.attributeInputTextField.text = textFieldContent
        return cell
    }
    
    private func setUpRelationCell(at indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ralationCell", for: indexPath)
        cell.textLabel?.text = "\(tableContent[indexPath.row])"
        return cell
    }
}

// MARK: - Extension
extension ObjectInfoView {
    enum ViewMode: Int {
        case add = 0, edit, view
    }
    
    enum ViewTarget: Int {
        case info = 0, relation
    }
    
    static let AttributeDecodedValue : [String : [String:String]] = [
        "Student" :     ["First name" : "firstName",
                         "Last name" : "lastName",
                         "Email" : "email",
                         "Student ID" : "id",
                         "Phone number" : "phone",
                         "Campus address" : "campusAddress"],
        
        "Professor" :   ["First name" :"firstName",
                         "Last name" : "lastName",
                         "Email" : "email",
                         "Home address" : "homeAddress",
                         "Office address" : "officeAddress"],
        
        "Course" :      ["Department code" : "departmentCode",
                         "Course number" : "number",
                         "Course name" : "name",
                         "Meeting days" : "meetingDay",
                         "Time" : "time",
                         "Location" : "location"]
    ]
    
    static let AttributeNames = [
        "Student" : ["First name", "Last name", "Email", "Student ID", "Phone number", "Campus address"],
        "Professor" : ["First name", "Last name", "Email", "Home address", "Office address"],
        "Course" : ["Department code", "Course number", "Course name", "Meeting days", "Time", "Location"]
    ]
}

//extension UIViewController {
//    @objc func presentImagePicker() {}
//}
