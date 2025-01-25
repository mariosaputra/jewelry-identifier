import Foundation
import SwiftData

@Model
final class IdentifyHistory: Codable {
    @Attribute(.externalStorage)
    var imageData: Data?
    
    var jewelryInfo: JewelryInfo?
    
    var timestamp: Date = Date()

    enum CodingKeys: String, CodingKey {
        case imageData
        case jewelryInfo
        case timestamp
    }

    init(imageData: Data?, jewelryInfo: JewelryInfo, timestamp: Date = Date()) {
        self.imageData = imageData
        self.jewelryInfo = jewelryInfo
        self.timestamp = timestamp
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.imageData = try container.decodeIfPresent(Data.self, forKey: .imageData)
        self.jewelryInfo = try container.decodeIfPresent(JewelryInfo.self, forKey: .jewelryInfo)
        self.timestamp = try container.decode(Date.self, forKey: .timestamp)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(imageData, forKey: .imageData)
        try container.encodeIfPresent(jewelryInfo, forKey: .jewelryInfo)
        try container.encode(timestamp, forKey: .timestamp)
    }
}
