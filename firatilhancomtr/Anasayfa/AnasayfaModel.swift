

import Foundation

struct AnasayfaModel: Codable,Sendable {
    let anasayfaFoto: String
    let anasayfaBaslik: String
    let anasayfaIcerik: String
    
    enum CodingKeys: String, CodingKey {
        case anasayfaFoto = "anasayfa_foto"
        case anasayfaBaslik = "anasayfa_baslik"
        case anasayfaIcerik = "anasayfa_icerik"
    }
}
