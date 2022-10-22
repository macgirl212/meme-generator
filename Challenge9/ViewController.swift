//
//  ViewController.swift
//  Challenge9
//
//  Created by Melody Davis on 10/22/22.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet var imageView: UIImageView!
    var currentImage: UIImage!
    var topText: String = ""
    var bottomText: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.alpha = 0
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editText))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(importImage))
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else {
            fatalError("There was an error in selecting an image.")
        }
        
        dismiss(animated: true)
        
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        
        let renderedImage = renderer.image { ctx in
            let baseImage = image
            currentImage = image
            
            baseImage.draw(at: CGPoint(x: 0, y: 0))
            
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .center
            
            let attrs: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 36),
                .foregroundColor: UIColor.white,
                .strokeColor: UIColor.black,
                .paragraphStyle: paragraphStyle
            ]
            
            let attributedTopString = NSAttributedString(string: topText, attributes: attrs)
            attributedTopString.draw(with: CGRect(x: 32, y: 10, width: 448, height: 448), options: .usesLineFragmentOrigin, context: nil)
            
            let attributedBottomString = NSAttributedString(string: bottomText, attributes: attrs)
            attributedBottomString.draw(with: CGRect(x: 32, y: 460, width: 448, height: 448), options: .usesLineFragmentOrigin, context: nil)
        }
        
        self.imageView.alpha = 0
        imageView.image = renderedImage
        
        UIView.animate(withDuration: 0.5, delay: 0, options: [], animations: {
            self.imageView.alpha = 1
        })
    }
    
    @objc func importImage() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
    
    @objc func editText() {
        let ac = UIAlertController(title: "Enter top text", message: nil, preferredStyle: .alert)
        ac.addTextField()
        
        // change top text
        let submitTopText = UIAlertAction(title: "Enter", style: .default) { [weak self] _ in
            guard let newTopText = ac.textFields?[0].text else { return }
            self?.topText = newTopText
            
            // change bottom text
            let acBottom = UIAlertController(title: "Enter bottom text", message: nil, preferredStyle: .alert)
            acBottom.addTextField()
            
            let submitBottomText = UIAlertAction(title: "Enter", style: .default) { _ in
                guard let newBottomText = acBottom.textFields?[0].text else { return }
                self?.bottomText = newBottomText
                
                // rerender image
                let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
                let renderedImage = renderer.image { ctx in
                    self?.currentImage.draw(at: CGPoint(x: 0, y: 0))
                    let paragraphStyle = NSMutableParagraphStyle()
                    paragraphStyle.alignment = .center
                    
                    let attrs: [NSAttributedString.Key: Any] = [
                        .font: UIFont.systemFont(ofSize: 36),
                        .foregroundColor: UIColor.white,
                        .strokeColor: UIColor.black,
                        .paragraphStyle: paragraphStyle
                    ]
                    
                    let attributedTopString = NSAttributedString(string: self?.topText ?? "", attributes: attrs)
                    attributedTopString.draw(with: CGRect(x: 32, y: 10, width: 448, height: 448), options: .usesLineFragmentOrigin, context: nil)
                    
                    let attributedBottomString = NSAttributedString(string: self?.bottomText ?? "", attributes: attrs)
                    attributedBottomString.draw(with: CGRect(x: 32, y: 460, width: 448, height: 448), options: .usesLineFragmentOrigin, context: nil)
                }
                
                self?.imageView.image = renderedImage
            }
            
            acBottom.addAction(submitBottomText)
            self?.present(acBottom, animated: true)
        }
        
        ac.addAction(submitTopText)
        present(ac, animated: true)
    }
}

