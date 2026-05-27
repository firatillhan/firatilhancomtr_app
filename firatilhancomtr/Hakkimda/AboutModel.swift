import Foundation


struct AboutModel: Codable,Sendable {
    let aboutTitle: String
    let aboutContent: String
    
    enum CodingKeys: String, CodingKey {
        case aboutTitle = "hakkimda_baslik"
        case aboutContent = "hakkimda_icerik"
    }
}
