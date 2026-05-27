import Foundation
import Alamofire
import UIKit

class AboutViewModel {
    
    var onSuccess: (() -> Void)?
    var onError: ((String) -> Void)?
    
    private(set) var about: AboutModel?
    
    func fetchAbout() {
        let url = "https://\(Bundle.main.baseURL)?endpoint=hakkimda"
        print(url)

        AF.request(url).responseData { [weak self] response in
            switch response.result {
            case .success(let data):
                do {
                    let result = try JSONDecoder().decode(AboutModel.self, from: data)
                    DispatchQueue.main.async {
                        self?.about = result
                        self?.onSuccess?()
                    }
                } catch {
                    DispatchQueue.main.async {
                        self?.onError?("Parse error: \(error.localizedDescription)")
                    }
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.onError?(error.localizedDescription)
                }
            }
        }
    }
    
    var title: String { about?.aboutTitle ?? "" }
    var content: String {
        guard let contentHTML = about?.aboutContent,
              let data = contentHTML.data(using: .utf8),
              let attributed = try? NSAttributedString(
                  data: data,
                  options: [.documentType: NSAttributedString.DocumentType.html,
                            .characterEncoding: String.Encoding.utf8.rawValue],
                  documentAttributes: nil
              ) else { return about?.aboutContent ?? "" }
        return attributed.string
    }
}
