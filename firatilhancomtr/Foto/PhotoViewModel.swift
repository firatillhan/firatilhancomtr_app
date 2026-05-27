
import Foundation
import Alamofire
class PhotoViewModel {
    
    var onSuccess: (() -> Void)?
    var onError: ((String) -> Void)?
    
    private(set) var photos: [PhotoModel] = []
    private(set) var cities: [String] = []
    
    
    private var currentPage = 1
    private var totalPage = 1
    private(set) var selectedCity: String? = nil
    var loading = false

    var more: Bool {
        return currentPage < totalPage
    }
    
    func fetchPhotos(city: String? = nil, newSearch: Bool = true) {
        guard !loading else { return }
        
        if newSearch {
            currentPage = 1
            photos = []
            selectedCity = city
        } else {
            currentPage += 1
        }
        
        loading = true
        var url = "\(Bundle.main.baseURL)?endpoint=foto&sayfa=\(currentPage)"
        if let city = selectedCity {
            url += "&sehir=\(city)"
        }
        
        AF.request(url).responseData { [weak self] response in
            guard let self else { return }
            loading = false
            switch response.result {
            case .success(let data):
                do {
                    let result = try JSONDecoder().decode(PhotoResponse.self, from: data)
                    self.photos += result.photos
                    self.cities = result.cities
                    self.totalPage = result.totalPage
                    DispatchQueue.main.async {
                        self.onSuccess?()
                    }
                } catch {
                    DispatchQueue.main.async {
                        self.onError?("Parse error: \(error.localizedDescription)")
                    }
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.onError?(error.localizedDescription)
                }
            }
        }
    }
    
    
    func addAllCities() {
        if !cities.contains("All") {
            cities.insert("All", at: 0)
        }
    }
    

}

