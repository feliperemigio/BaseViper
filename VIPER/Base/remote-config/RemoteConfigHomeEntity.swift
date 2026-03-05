//
//  RemoteConfigHomeEntity.swift
//  VIPER
//

import Foundation

final class RemoteConfigHomeEntity: Codable {

    var isSalesButtonEnabled: Bool

    enum CodingKeys: String, CodingKey {
        case isSalesButtonEnabled = "IS_SALES_BUTTON_ENABLED"
    }

    init(isSalesButtonEnabled: Bool = false) {
        self.isSalesButtonEnabled = isSalesButtonEnabled
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        isSalesButtonEnabled = try container.decodeIfPresent(Bool.self, forKey: .isSalesButtonEnabled) ?? false
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(isSalesButtonEnabled, forKey: .isSalesButtonEnabled)
    }
}
