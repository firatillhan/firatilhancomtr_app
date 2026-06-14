//
//  AddPhotoResponse.swift
//  firatilhancomtr
//
//  Created by Fırat İlhan on 3.06.2026.
//

import Foundation

@MainActor
struct AddPhotoResponse: Codable,Sendable {
    let basari: Bool?
    let hata: String?
}
