//
//  AddPhotoViewModel.swift
//  firatilhancomtr
//
//  Created by Fırat İlhan on 3.06.2026.
//

import Foundation
import Alamofire
import UIKit

class AddPhotoViewModel {
   
    var onStateChanged: ((State) -> Void)?

    func addPhoto(image: UIImage, name: String, detail: String, location: String, city: String,lat: Double?, lng: Double?) {
        
        guard let imageData = image.jpegData(compressionQuality: 0.3) else {
            onStateChanged?(.error("Fotoğraf dönüştürülemedi"))
            return
        }
        let url = "https://\(Bundle.main.addURL)?action=foto_ekle"
        print("URL: \(url)")

        AF.upload(multipartFormData: { formData in
            formData.append(imageData, withName: "foto_resim", fileName: "photo.jpg", mimeType: "image/jpeg")
            formData.append(Data(name.utf8), withName: "foto_ad")
            formData.append(Data(detail.utf8), withName: "foto_detay")
            formData.append(Data(location.utf8), withName: "foto_konum")
            if let lat = lat {
                formData.append(Data("\(lat)".utf8), withName: "foto_enlem")
            }
            if let lng = lng {
                formData.append(Data("\(lng)".utf8), withName: "foto_boylam")
            }
            
            formData.append(Data(city.utf8), withName: "foto_sehir")
            formData.append(Data("foto_ekle".utf8), withName: "action")
        }, to: url)
        
        .responseData { [weak self] response in
            switch response.result {
            case .success(let data):
                print(String(data: data, encoding: .utf8) ?? "okunamadı")
                do {
                    let result = try JSONDecoder().decode(AddPhotoResponse.self, from: data)
                    if result.basari == true {
                        self?.onStateChanged?(.success)
                    } else {
                        self?.onStateChanged?(.error("Bilinmeyen hata"))
                    }
                } catch {
                    self?.onStateChanged?(.error("Parse hatası: \(error.localizedDescription)"))
                }
            case .failure(let error):
                self?.onStateChanged?(.error(error.localizedDescription))
            }
        }
    }
}
