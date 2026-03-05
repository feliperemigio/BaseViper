//
//  RemoteConfigHomeEntity.swift
//  VIPER
//

import Foundation

final class RemoteConfigHomeEntity: Codable {

    enum ButtonType: String, Codable {
        case red = "red"
        case white = "white"
    }

    var isSalesButtonEnabled: Bool
    var type: ButtonType

    enum CodingKeys: String, CodingKey {
        case isSalesButtonEnabled = "IS_SALES_BUTTON_ENABLED"
        case type = "TYPE"
    }

    init(isSalesButtonEnabled: Bool = false, type: ButtonType = .red) {
        self.isSalesButtonEnabled = isSalesButtonEnabled
        self.type = type
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        isSalesButtonEnabled = try container.decodeIfPresent(Bool.self, forKey: .isSalesButtonEnabled) ?? false
        type = try container.decodeIfPresent(ButtonType.self, forKey: .type) ?? .red
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(isSalesButtonEnabled, forKey: .isSalesButtonEnabled)
        try container.encode(type, forKey: .type)
    }
}
