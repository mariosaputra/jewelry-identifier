import Foundation
import SwiftData

@Model
final class JewelryInfo: Codable {
    var imageID: String?
    var name: String? // Name of the jewelry piece
    var type: String? // E.g., Ring, Necklace, Bracelet
    var material: String? // E.g., Gold, Silver, Platinum
    var gemstone: String? // E.g., Diamond, Ruby, Sapphire
    var gemstoneCarat: String? // Gemstone weight in carats
    var jewelryWeight: String? // Jewelry weight
    var origin: String? // Country or region of origin
    var era: String? // Historical era (e.g., Victorian, Art Deco)
    var estimatedValue: String? // Appraised or estimated market value
    var designDescription: String? // Description of design or style
    var historicalSignificance: String? // Any historical or cultural importance
    var rarity: String? // Common, Rare, Unique
    var grading: String? // For gemstones, e.g., VVS, IF
    var confidence: String? // Confidence in the identification process
    var notes: String? // Additional notes
    var identificationHistory: IdentifyHistory?

    init(imageID: String? = nil,
         name: String? = nil,
         type: String? = nil,
         material: String? = nil,
         gemstone: String? = nil,
         gemstoneCarat: String? = nil,
         jewelryWeight: String? = nil,
         origin: String? = nil,
         era: String? = nil,
         estimatedValue: String? = nil,
         designDescription: String? = nil,
         historicalSignificance: String? = nil,
         rarity: String? = nil,
         grading: String? = nil,
         confidence: String? = nil,
         notes: String? = nil) {
        self.imageID = imageID
        self.type = type
        self.material = material
        self.gemstone = gemstone
        self.gemstoneCarat = gemstoneCarat
        self.jewelryWeight = jewelryWeight
        self.origin = origin
        self.era = era
        self.estimatedValue = estimatedValue
        self.designDescription = designDescription
        self.historicalSignificance = historicalSignificance
        self.rarity = rarity
        self.grading = grading
        self.confidence = confidence
        self.notes = notes
    }
    
    enum CodingKeys: String, CodingKey {
        case imageID, name, type, material, gemstone, gemstoneCarat, jewelryWeight, origin, era, estimatedValue, designDescription, historicalSignificance, rarity, grading, confidence, notes, identificationHistory
    }
                
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        imageID = try container.decodeIfPresent(String.self, forKey: .imageID)
        name = try container.decodeIfPresent(String.self, forKey: .name)
        type = try container.decodeIfPresent(String.self, forKey: .type)
        material = try container.decodeIfPresent(String.self, forKey: .material)
        gemstone = try container.decodeIfPresent(String.self, forKey: .gemstone)
        gemstoneCarat = try container.decodeIfPresent(String.self, forKey: .gemstoneCarat)
        jewelryWeight = try container.decodeIfPresent(String.self, forKey: .jewelryWeight)
        origin = try container.decodeIfPresent(String.self, forKey: .origin)
        era = try container.decodeIfPresent(String.self, forKey: .era)
        estimatedValue = try container.decodeIfPresent(String.self, forKey: .estimatedValue)
        designDescription = try container.decodeIfPresent(String.self, forKey: .designDescription)
        historicalSignificance = try container.decodeIfPresent(String.self, forKey: .historicalSignificance)
        rarity = try container.decodeIfPresent(String.self, forKey: .rarity)
        grading = try container.decodeIfPresent(String.self, forKey: .grading)
        confidence = try container.decodeIfPresent(String.self, forKey: .confidence)
        notes = try container.decodeIfPresent(String.self, forKey: .notes)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(imageID, forKey: .imageID)
        try container.encodeIfPresent(name, forKey: .name)
        try container.encodeIfPresent(type, forKey: .type)
        try container.encodeIfPresent(material, forKey: .material)
        try container.encodeIfPresent(gemstone, forKey: .gemstone)
        try container.encodeIfPresent(gemstoneCarat, forKey: .gemstoneCarat)
        try container.encodeIfPresent(jewelryWeight, forKey: .jewelryWeight)
        try container.encodeIfPresent(origin, forKey: .origin)
        try container.encodeIfPresent(era, forKey: .era)
        try container.encodeIfPresent(estimatedValue, forKey: .estimatedValue)
        try container.encodeIfPresent(designDescription, forKey: .designDescription)
        try container.encodeIfPresent(historicalSignificance, forKey: .historicalSignificance)
        try container.encodeIfPresent(rarity, forKey: .rarity)
        try container.encodeIfPresent(grading, forKey: .grading)
        try container.encodeIfPresent(confidence, forKey: .confidence)
        try container.encodeIfPresent(notes, forKey: .notes)
    }
}
