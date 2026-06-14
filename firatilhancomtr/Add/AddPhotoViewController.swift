//
//  AddPhotoViewController.swift
//  firatilhancomtr
//
//  Created by Fırat İlhan on 2.06.2026.
//

import UIKit

class AddPhotoViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var photoNameLabel: UITextField!
    @IBOutlet weak var photoDetailLabel: UITextField!
    @IBOutlet weak var photoLocationLabel: UITextField!
    @IBOutlet weak var photoCityLabel: UITextField!

    private let addPhotoViewModel = AddPhotoViewModel()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        containerView.backgroundColor = .clear
        // Do any additional setup after loading the view.
        imageView.isUserInteractionEnabled = true
        let tapImage = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tap:)))
        imageView.addGestureRecognizer(tapImage)
        bindViewModel()

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        let tapKeyboard = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapKeyboard)
    }
    @objc private func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            view.frame.origin.y = -keyboardSize.height
        }
    }

    @objc private func keyboardWillHide(notification: NSNotification) {
        view.frame.origin.y = 0
    }
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    @objc func imageTapped(tap: UITapGestureRecognizer) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        present(picker, animated: true)
    }

    @IBAction func photoAddButton(_ sender: Any) {
        print("ekle tıklandı")
        guard let image = imageView.image else {
            print("Fotoğraf seçilmedi")
            return
        }
        
        let name = photoNameLabel.text ?? ""
        let detail = photoDetailLabel.text ?? ""
        let location = photoLocationLabel.text ?? ""
        let city = photoCityLabel.text ?? ""
        
        addPhotoViewModel.addPhoto(image: image, name: name, detail: detail, location: location, city: city)
    }
    
    private func bindViewModel() {
        
        addPhotoViewModel.onSuccess = { [weak self] in
            guard let self else { return }
            NotificationCenter.default.post(name: NSNotification.Name("PhotoAdded"), object: nil)
            DispatchQueue.main.async {
                self.navigationController?.popViewController(animated: true)
            }
        }
        
        addPhotoViewModel.onError = { error in
            print("Hata: \(error)")
        }
    }
        

}

extension AddPhotoViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let image = info[.editedImage] as? UIImage {
            imageView.image = image
        }
        dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }
}
