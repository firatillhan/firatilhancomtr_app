

import UIKit
import SDWebImage
class PhotosViewController: UIViewController {
    
    @IBOutlet weak var citiesTextField: UITextField!
    @IBOutlet weak var filterButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    
    private let photoViewModel = PhotoViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        bindViewModel()
        photoViewModel.fetchPhotos()
        let layout = UICollectionViewFlowLayout()
        let width = (view.frame.width - 3) / 2
        layout.itemSize = CGSize(width: width, height: width)
        layout.minimumInteritemSpacing = 1
        layout.minimumLineSpacing = 1
        collectionView.collectionViewLayout = layout
        
        let picker = UIPickerView()
        picker.delegate = self
        picker.dataSource = self
        citiesTextField.inputView = picker

        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let done = UIBarButtonItem(title: "Select", style: .done, target: self, action: #selector(citySelected))
        toolbar.setItems([done], animated: false)
        citiesTextField.inputAccessoryView = toolbar
        NotificationCenter.default.addObserver(self, selector: #selector(photoAdded), name: NSNotification.Name("PhotoAdded"), object: nil)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
 
        
    }
    
    private func bindViewModel() {
        photoViewModel.onSuccess = { [weak self] in
            guard let self else { return }
            photoViewModel.addAllCities()
            collectionView.reloadData()
        }
        
        photoViewModel.onError = { error in
            print("Error: \(error)")
        }
    }
    @IBAction func filterButtonPressed(_ sender: Any) {
        citiesTextField.becomeFirstResponder()

    }
    @objc private func citySelected() {
        citiesTextField.resignFirstResponder()
        guard let picker = citiesTextField.inputView as? UIPickerView else { return }
        let select = photoViewModel.cities[picker.selectedRow(inComponent: 0)]
        
        if select == "All" {
            citiesTextField.text = ""
            photoViewModel.fetchPhotos(city: nil, newSearch: true)
            
        } else {
            citiesTextField.text = select
            photoViewModel.fetchPhotos(city: select, newSearch: true)
        }
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let frameHeight = scrollView.frame.height
        
        if offsetY > contentHeight - frameHeight - 200 {
            if photoViewModel.more && !photoViewModel.loading {
                photoViewModel.fetchPhotos(city: photoViewModel.selectedCity, newSearch: false)
            }
        }
    }
    @objc private func photoAdded() {
        photoViewModel.fetchPhotos(city: photoViewModel.selectedCity, newSearch: true)
    }
    
}

extension PhotosViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photoViewModel.photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotosCollectionViewCell", for: indexPath) as! PhotosCollectionViewCell
        let photo = photoViewModel.photos[indexPath.item]
        let url = URL(string: "https://www.firatilhan.com.tr/\(photo.photo)")
//        cell.fotoImageView.sd_setImage(with: url)
        let cellWidth = collectionView.frame.width / 2
        let scale = traitCollection.displayScale
        let thumbnailSize = CGSize(width: cellWidth * scale, height: cellWidth * scale)
        cell.photoImageView.sd_setImage(with: url, placeholderImage: nil, options: [], context: [.imageThumbnailPixelSize: thumbnailSize])
        return cell
    }
}
extension PhotosViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int { 1 }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return photoViewModel.cities.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return photoViewModel.cities[row]
    }
}
