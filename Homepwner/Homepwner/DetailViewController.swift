//
//  DetailViewController.swift
//  Homepwner
//
//  Created by Pankova Mariya on 10.05.17.
//  Copyright © 2017 Pankova Mariya. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, UITextFieldDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @IBOutlet var nameField: ColorBorderResponderTextField!
    @IBOutlet var serialNumberField: ColorBorderResponderTextField!
    @IBOutlet var valueField: ColorBorderResponderTextField!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var imageView: UIImageView!
    
    var item: Item! {
        didSet {
            navigationItem.title = item.name
        }
    }
    
    let numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        return formatter
    }()
    
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }()
    
    var imageStore: ImageStore!
    
    
    // MARK: - ImagePicker
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        // 14: bronze
        let image = info[UIImagePickerControllerEditedImage] as! UIImage
        imageStore.setImage(image: image, forkey: item.itemKey)
        imageView.image = image
        dismiss(animated: true, completion: nil)
    }

    
    // MARK: - ButtonActions
    
    @IBAction func takePicture(_ sender: UIBarButtonItem) {
        let imagePicker = UIImagePickerController()
        // 14: bronze
        imagePicker.allowsEditing = true
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePicker.sourceType = .camera
            // 14: gold
            let cameraOverlay = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
            imagePicker.cameraOverlayView = cameraOverlay
        } else {
            imagePicker.sourceType = .photoLibrary
        }
        
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
    
    // 14: silver
    @IBAction func deletePicture(_ sender: UIBarButtonItem) {
        let key = item.itemKey
        imageStore.deleteImageForKey(key: key)
        imageView.image = imageStore.imageForKey(key: key)
    }
    
    @IBAction func backgroundTapped(_ sender: AnyObject) {
        view.endEditing(true)
    }
    
    func setDate(_ date: Date) {
        let stringDate = dateFormatter.string(from: date)
        dateLabel.text = stringDate
    }
    
    
    // MARK: - View life cycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        nameField.text = item.name
        serialNumberField.text = item.serialNumber
        valueField.text = numberFormatter.string(from: NSNumber(value: item.valueInDollars))
        dateLabel.text = dateFormatter.string(from: item.dateCreated)
        
        let key = item.itemKey
        let imageToDisplay = imageStore.imageForKey(key: key)
        imageView.image = imageToDisplay
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        view.endEditing(true)
        
        item.name = nameField.text ?? ""
        item.serialNumber = serialNumberField.text
        
        if let valueText = valueField.text, let value = numberFormatter.number(from: valueText) {
            item.valueInDollars = value.intValue
        } else {
            item.valueInDollars = 0
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    // MARK: - Segue
    
    // 13: gold
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SetDate" {
            let chooseDateViewController = segue.destination as! ChooseDateViewController
            chooseDateViewController.item = item
        }
    }
}
