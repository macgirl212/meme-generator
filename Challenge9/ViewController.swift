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
                .font: UIFont.boldSystemFont(ofSize: 50),
                .foregroundColor: UIColor.white,
                .paragraphStyle: paragraphStyle
            ]
            
            let attributedTopString = NSAttributedString(string: topText, attributes: attrs)
            attributedTopString.draw(with: CGRect(x: 32, y: 0, width: 448, height: 448), options: .usesLineFragmentOrigin, context: nil)
            
            let attributedBottomString = NSAttributedString(string: bottomText, attributes: attrs)
            attributedBottomString.draw(with: CGRect(x: 32, y: 450, width: 448, height: 448), options: .usesLineFragmentOrigin, context: nil)
        }
        
        self.imageView.alpha = 0
        imageView.image = renderedImage
        
        UIView.animate(withDuration: 0.5, delay: 0, options: [], animations: {
            self.imageView.alpha = 1
        })
        
        // add extra buttons to navigation controller
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editText))
        navigationItem.rightBarButtonItems = [UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(importImage)), UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveImage))]
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
                        .font: UIFont.boldSystemFont(ofSize: 50),
                        .foregroundColor: UIColor.white,
                        .paragraphStyle: paragraphStyle
                    ]
                    
                    let attributedTopString = NSAttributedString(string: self?.topText ?? "", attributes: attrs)
                    attributedTopString.draw(with: CGRect(x: 32, y: 0, width: 448, height: 448), options: .usesLineFragmentOrigin, context: nil)
                    
                    let attributedBottomString = NSAttributedString(string: self?.bottomText ?? "", attributes: attrs)
                    attributedBottomString.draw(with: CGRect(x: 32, y: 450, width: 448, height: 448), options: .usesLineFragmentOrigin, context: nil)
                }
                
                self?.imageView.image = renderedImage
            }
            
            acBottom.addAction(submitBottomText)
            self?.present(acBottom, animated: true)
        }
        
        ac.addAction(submitTopText)
        present(ac, animated: true)
    }
    
    @objc func saveImage() {
        let ac = UIAlertController(title: "Are you sure you want to save?", message: nil, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Yes", style: .default, handler: { [weak self] _ in
            guard let image = self?.imageView.image else {
                let ac = UIAlertController(title: "Error", message: "There is no image to save.", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "OK", style: .default))
                self?.present(ac, animated: true)
                return
            }
            UIImageWriteToSavedPhotosAlbum(image, self, #selector(self!.image(_:didFinishSavingWithError:contextInfo:)), nil)
        }))
        ac.addAction(UIAlertAction(title: "No", style: .cancel))
        present(ac, animated: true)
    }
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            let ac = UIAlertController(title: "Save error", message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
        } else {
            let ac = UIAlertController(title: "Saved!", message: "Your meme has been saved to your photos.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
    }
}

