//
//  ViewController.swift
//  MediaCapture
//
//  Created by Patrick Nymark on 30/07/2020.
//  Copyright © 2020 Patrick Nymark. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var imagePicker = UIImagePickerController()
    var originalImage = UIImage()
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var photosBtn: UIButton!
    @IBOutlet weak var cameraBtn: UIButton!
    @IBOutlet weak var addBtn: UIButton!
    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var clearBtn: UIButton!
    
    @IBOutlet weak var textField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        imagePicker.delegate = self
        
        photosBtn.addTarget(self, action: #selector(self.handlePhotos), for: .touchUpInside)
        cameraBtn.addTarget(self, action: #selector(self.handleCamera), for: .touchUpInside)
        addBtn.addTarget(self, action: #selector(self.drawText), for: .touchUpInside)
        saveBtn.addTarget(self, action: #selector(self.handleSave), for: .touchUpInside)
        clearBtn.addTarget(self, action: #selector(self.clear), for: .touchUpInside)
    }
    
    @objc func handlePhotos() {
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
    }
    
    @objc func handleCamera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePicker.sourceType = .camera
            imagePicker.showsCameraControls = true
            imagePicker.allowsEditing = true
            present(imagePicker, animated: true, completion: nil)
        } else {
            let ac = UIAlertController(title: "Not Available!", message: "Only available on real devices", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)

        }

    }

    @objc func drawText() {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        let img = renderer.image { ctx in
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .center
            
            let attr: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 30),
                .paragraphStyle: paragraphStyle,
            ]
            
            guard let string = textField.text else { return }
            
            let attributedString = NSAttributedString(string: string, attributes: attr)
            
            attributedString.draw(with: CGRect(x: 32, y: 32, width: 448, height: 448), options: .usesLineFragmentOrigin, context: nil)
            
            imageView.image?.draw(at: CGPoint(x: 10, y: 150))
        }

        imageView.image = img
    }
    
    @objc func handleSave() {
        print("clicked")
        guard let image = imageView.image else { return }
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(self.didFinishSaving), nil)
    }
    
    
    @objc func didFinishSaving(_ image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            // we got back an error!
            let ac = UIAlertController(title: "Error Saving", message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        } else {
            imageView.image = nil
            textField.text = ""
            let ac = UIAlertController(title: "Saved!", message: "Your image has been saved to your photos.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
    }
    
    @objc func clear() {
        imageView.image = originalImage
    }
}

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else { return }
        imageView.image = image
        originalImage = image
        picker.dismiss(animated: true, completion: nil)
    }
}



