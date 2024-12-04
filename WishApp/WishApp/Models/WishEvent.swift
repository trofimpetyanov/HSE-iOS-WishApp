import UIKit

struct WishEvent {
    let uuid: UUID
    let title: String
    let description: String?
    let startDate: Date
    let endDate: Date
    let color: UIColor
    
    init(uuid: UUID = UUID(), title: String, description: String?, startDate: Date, endDate: Date, color: UIColor) {
        self.uuid = uuid
        self.title = title
        self.description = description
        self.startDate = startDate
        self.endDate = endDate
        self.color = color
    }
}

extension WishEvent: Hashable { }

extension WishEvent: Codable {
    enum CodingKeys: String, CodingKey {
        case uuid
        case title
        case description
        case startDate
        case endDate
        case color
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(uuid, forKey: .uuid)
        try container.encode(title, forKey: .title)
        try container.encode(description, forKey: .description)
        try container.encode(startDate, forKey: .startDate)
        try container.encode(endDate, forKey: .endDate)
        
        let colorData = try NSKeyedArchiver.archivedData(withRootObject: color, requiringSecureCoding: false)
        try container.encode(colorData, forKey: .color)
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        uuid = try container.decode(UUID.self, forKey: .uuid)
        title = try container.decode(String.self, forKey: .title)
        description = try container.decode(String?.self, forKey: .description)
        startDate = try container.decode(Date.self, forKey: .startDate)
        endDate = try container.decode(Date.self, forKey: .endDate)
        
        let colorData = try container.decode(Data.self, forKey: .color)
        color = try NSKeyedUnarchiver.unarchivedObject(ofClass: UIColor.self, from: colorData) ?? .clear
    }
}

extension WishEvent: Storagable {
    static var storageName: String { "wishEvents" }
}
