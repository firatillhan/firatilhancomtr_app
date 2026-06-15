
import Foundation



struct PhotoModel: Codable,Sendable {
    let photoName: String
    let photoDetail: String
    let photo: String
    let photoLocation: String
    let photoTime: String
    let photoCity: String
    let photoLat: String?
    let photoLng: String?
    
    enum CodingKeys: String, CodingKey {
        case photoName = "foto_ad"
        case photoDetail = "foto_detay"
        case photo = "foto_resim"
        case photoLocation = "foto_konum"
        case photoTime = "foto_zaman"
        case photoCity = "foto_sehir"
        case photoLat = "foto_enlem"
        case photoLng = "foto_boylam"
    }
}



struct PhotoResponse: Codable, Sendable {
    let photos: [PhotoModel]
    let cities: [String]
    let totalPage: Int
    
    enum CodingKeys: String, CodingKey {
        case photos = "fotolar"
        case cities = "sehirler"
        case totalPage = "toplam_sayfa"
    }
}
