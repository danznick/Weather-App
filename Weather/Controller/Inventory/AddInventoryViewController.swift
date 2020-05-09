//
//  AddClothViewController.swift
//  Weather
//
//  Created by Daniel Gomes on 27/03/20.
//  Copyright © 2020 Daniel Gomes. All rights reserved.
//

import UIKit
protocol ClotheData: class {
    func refresh()
}
class AddInventoryViewController: UIViewController { //Add items
    
    @IBOutlet weak var txtType: UITextField!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var btnCategory: UIButton!
    @IBOutlet weak var waterSeg: UISegmentedControl!
    @IBOutlet weak var txtFeature: UITextView!
    @IBOutlet weak var txtCloValue: UITextField!
    @IBOutlet weak var txtPrice: UITextField!
    @IBOutlet weak var txtWeight: UITextField!
    weak var delegate: ClotheData?
    fileprivate let pickerView = ToolbarPickerView()
    fileprivate let typeTitles = ["Camping", "Backpacking","Rock Climbing", "Camp Chores", "Other",]
    var modelWeather: Weather?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        uiConfiguration()
        pickerViewConfiguration()
    }
    
    
    func uiConfiguration(){
        let tap = UITapGestureRecognizer(target: self, action: #selector(imgTapped))
        tap.numberOfTapsRequired = 1
        img.isUserInteractionEnabled = true
        img.addGestureRecognizer(tap)
        txtFeature.delegate = self
        txtName.placeholderColor(color: .white)
        txtCloValue.placeholderColor(color: .white)
        txtPrice.placeholderColor(color: .white)
        txtWeight.placeholderColor(color: .white)
        // txtFeature.placeholderColor(color: .white)
        txtType.placeholderColor(color: .white)
    }
    
    func pickerViewConfiguration(){
        self.txtType.inputView = self.pickerView
        self.txtType.inputAccessoryView = self.pickerView.toolbar
        self.pickerView.dataSource = self
        self.pickerView.delegate = self
        self.pickerView.toolbarDelegate = self
        self.pickerView.reloadAllComponents()
    }
    
    @objc
    func imgTapped(){
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            let picker = UIImagePickerController()
            picker.delegate = self
            picker.sourceType = .photoLibrary
            self.navigationController?.present(picker, animated: true)
        }
    }
    @IBAction func btnCategoryClick(_ sender: UIButton) {
        let categoryVC = CategoryViewController.shareInstance()
        categoryVC.category = self
        self.navigationController?.pushViewController(categoryVC, animated: true)
    }
    
    @IBAction func segmentTapped(_ sender: UISegmentedControl) {
    }
    
    @IBAction func btnSaveClick(_ sender: UIBarButtonItem) {
        guard let name = txtName.text else { return }
        guard let type = txtType.text else { return }
        guard let feature = txtFeature.text else { return }
        guard let cloValue = txtCloValue.text else { return }
        guard let price = txtPrice.text else { return }
        guard let img = img.image else { return }
        guard let category = btnCategory.currentTitle else { return }
        guard let weight = txtWeight.text else { return }
        let isGear = waterSeg.selectedSegmentIndex == 0 ? true : false
        var message = ""
        if name == ""{
            message = "Please enter name"
        }else if type == ""{
            message = "Please enter type"
        }else if price == ""{
            message = "Please enter price"
        }else if cloValue == ""{
            message = "Please enter cloValue"
        }else if weight == ""{
            message = "Please enter weight"
        }else if category == "Select Category"{
            message = "Please enter category"
        }else{
            let strTimeStamp = "\(Date().getTimeStamp).jpg"
            strTimeStamp.saveImageDocumentDirectory(img: img) //Saves to document folder
            
            let modelClothe = InventoryModel(name: name, category: category, type: type, isGear: isGear, price: price, feature: feature, cloValue: cloValue, imgPath: strTimeStamp, weight: weight)
            if modelWeather != nil{
                DatabaseHelper.shareInstance.saveinventory(modelClothe: modelClothe, weather: modelWeather!)//     Singleton share instance
                delegate?.refresh()
            }else{
                popupAlert(title: "", message: "Please try again", alertControllerStyle: .alert, actionTitles: ["Okay"], actionStyles: [.default], alertActions: [{_ in}])
            }
            
            self.navigationController?.popViewController(animated: true)
        }
        popupAlert(title: "Alert", message: message, alertControllerStyle: .alert, actionTitles: ["Okay"], actionStyles: [.default], alertActions: [{ _ in }])
    }
}

extension AddInventoryViewController{
    static func shareInstance() -> AddInventoryViewController{
        return AddInventoryViewController.instantiateFromStoryboard()
    }
}

extension AddInventoryViewController: UITextViewDelegate{
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == feature{
            textView.text = ""
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = feature            
        }
    }
}

extension AddInventoryViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.typeTitles.count
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.typeTitles[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.txtType.text = self.typeTitles[row]
    }
}

extension AddInventoryViewController: ToolbarPickerViewDelegate {
    
    func didTapDone() {
        let row = self.pickerView.selectedRow(inComponent: 0)
        self.pickerView.selectRow(row, inComponent: 0, animated: false)
        self.txtType.text = self.typeTitles[row]
        self.txtType.resignFirstResponder()
    }
    
    func didTapCancel() {
        self.txtType.text = nil
        self.txtType.resignFirstResponder()
    }
}

extension AddInventoryViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let img = info[.originalImage] as? UIImage{
            self.img.image = img
        }
        self.dismiss(animated: true)
    }
}

extension AddInventoryViewController: CategoryData{
    func categoryValues(name: String, cloValue: String) {
        btnCategory.setTitle(name, for: .normal)
        txtCloValue.text = cloValue
    }
}
