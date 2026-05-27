
import Alamofire
import SDWebImage



class AnasayfaViewModel {
    
    var onSuccess: (() -> Void)?
    var onError: ((String) -> Void)?
    
    private(set) var anasayfa: AnasayfaModel?
    
    func fetchAnasayfa() {
        let url = "https://\(Bundle.main.baseURL)?endpoint=anasayfa"
        print(url)
        AF.request(url).responseData { [weak self] response in
            switch response.result {
            case .success(let data):
                do {
                    let result = try JSONDecoder().decode(AnasayfaModel.self, from: data)
                    DispatchQueue.main.async {
                        self?.anasayfa = result
                        self?.onSuccess?()
                    }
                } catch {
                    DispatchQueue.main.async {
                        self?.onError?("Parse hatası: \(error.localizedDescription)")
                    }
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.onError?(error.localizedDescription)
                }
            }
        }
    }
    
    var baslik: String { anasayfa?.anasayfaBaslik ?? "" }
    var icerik: String { anasayfa?.anasayfaIcerik ?? "" }
    var fotoURL: URL? {
        guard let path = anasayfa?.anasayfaFoto else { return nil }
        return URL(string: "https://www.firatilhan.com.tr/\(path)")
    }
}
