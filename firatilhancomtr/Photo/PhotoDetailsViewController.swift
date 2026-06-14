//
//  PhotoDetailsViewController.swift
//  firatilhancomtr
//
//  Created by Fırat İlhan on 14.06.2026.
//

import UIKit
import SDWebImage

class PhotoDetailsViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var photoNameLabel: UILabel!
    @IBOutlet weak var photoDetailLabel: UILabel!
    @IBOutlet weak var photoLocationLabel: UILabel!
    @IBOutlet weak var photoCityLabel: UILabel!
    @IBOutlet weak var photoTimeLabel: UILabel!

    var photo: PhotoModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        guard let photo = photo else { return }
        
        photoNameLabel.text = photo.photoName
        photoDetailLabel.text = photo.photoDetail
        photoLocationLabel.text = "📍 \(photo.photoLocation)"
        photoCityLabel.text = photo.photoCity
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        if let date = formatter.date(from: photo.photoTime) {
            formatter.dateFormat = "dd MMMM yyyy"
            photoTimeLabel.text = formatter.string(from: date)
        }
        
        let url = URL(string: "https://www.firatilhan.com.tr/\(photo.photo)")
        imageView.sd_setImage(with: url)
        
        let pinch = UIPinchGestureRecognizer(target: self, action: #selector(pinchGesture))
        imageView.addGestureRecognizer(pinch)
        imageView.isUserInteractionEnabled = true
        
    }
    
    @objc private func pinchGesture(_ gesture: UIPinchGestureRecognizer) {
        imageView.transform = imageView.transform.scaledBy(x: gesture.scale, y: gesture.scale)
        gesture.scale = 1
        
        if gesture.state == .began {
            setLabelsHidden(true)
        } else if gesture.state == .ended {
            UIView.animate(withDuration: 0.3) {
                self.imageView.transform = .identity
            }
            setLabelsHidden(false)
        }
    }

    private func setLabelsHidden(_ hidden: Bool) {
        photoNameLabel.isHidden = hidden
        photoTimeLabel.isHidden = hidden
        photoLocationLabel.isHidden = hidden
        photoCityLabel.isHidden = hidden
        photoDetailLabel.isHidden = hidden
    }

}
