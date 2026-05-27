//
//  Bundle.swift
//  firatilhancomtr
//
//  Created by Fırat İlhan on 27.05.2026.
//

import Foundation

extension Bundle {
    var baseURL: String {
        return infoDictionary?["BASE_URL"] as? String ?? ""
    }
}
