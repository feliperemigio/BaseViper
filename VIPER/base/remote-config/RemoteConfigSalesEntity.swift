import Foundation

// MARK: - RemoteConfigSalesEntity

class RemoteConfigSalesEntity: Codable {

    // MARK: - Properties

    var isEnabled: Bool
    var discountPercentage: Double
    var promotionTitle: String
    var bannerUrl: String
    var maxInstallments: Int
    var freeShippingThreshold: Double
    var campaignTag: String
    var expirationDate: String

    // MARK: - CodingKeys

    enum CodingKeys: String, CodingKey {
        case isEnabled          = "IS_ENABLED"
        case discountPercentage = "DISCOUNT_PERCENTAGE"
        case promotionTitle     = "PROMOTION_TITLE"
        case bannerUrl          = "BANNER_URL"
        case maxInstallments    = "MAX_INSTALLMENTS"
        case freeShippingThreshold = "FREE_SHIPPING_THRESHOLD"
        case campaignTag        = "CAMPAIGN_TAG"
        case expirationDate     = "EXPIRATION_DATE"
    }

    // MARK: - Init

    init(
        isEnabled: Bool = false,
        discountPercentage: Double = 0.0,
        promotionTitle: String = "",
        bannerUrl: String = "",
        maxInstallments: Int = 1,
        freeShippingThreshold: Double = 0.0,
        campaignTag: String = "",
        expirationDate: String = ""
    ) {
        self.isEnabled = isEnabled
        self.discountPercentage = discountPercentage
        self.promotionTitle = promotionTitle
        self.bannerUrl = bannerUrl
        self.maxInstallments = maxInstallments
        self.freeShippingThreshold = freeShippingThreshold
        self.campaignTag = campaignTag
        self.expirationDate = expirationDate
    }

    // MARK: - Decodable

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        isEnabled          = try container.decodeIfPresent(Bool.self,   forKey: .isEnabled)          ?? false
        discountPercentage = try container.decodeIfPresent(Double.self, forKey: .discountPercentage) ?? 0.0
        promotionTitle     = try container.decodeIfPresent(String.self, forKey: .promotionTitle)     ?? ""
        bannerUrl          = try container.decodeIfPresent(String.self, forKey: .bannerUrl)          ?? ""
        maxInstallments    = try container.decodeIfPresent(Int.self,    forKey: .maxInstallments)    ?? 1
        freeShippingThreshold = try container.decodeIfPresent(Double.self, forKey: .freeShippingThreshold) ?? 0.0
        campaignTag        = try container.decodeIfPresent(String.self, forKey: .campaignTag)        ?? ""
        expirationDate     = try container.decodeIfPresent(String.self, forKey: .expirationDate)     ?? ""
    }

    // MARK: - Encodable

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(isEnabled,             forKey: .isEnabled)
        try container.encode(discountPercentage,    forKey: .discountPercentage)
        try container.encode(promotionTitle,        forKey: .promotionTitle)
        try container.encode(bannerUrl,             forKey: .bannerUrl)
        try container.encode(maxInstallments,       forKey: .maxInstallments)
        try container.encode(freeShippingThreshold, forKey: .freeShippingThreshold)
        try container.encode(campaignTag,           forKey: .campaignTag)
        try container.encode(expirationDate,        forKey: .expirationDate)
    }
}
