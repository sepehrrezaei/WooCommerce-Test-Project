//
//  ProductScheme.swift
//  WoocoTestProject
//
//  Created by Sepehr Rezaei on 12/12/21.
//

import Foundation
import RealmSwift

class ProductScheme: Object {
    @objc dynamic var id: Int = 0
    @objc dynamic var name: String = ""
    @objc dynamic var permalink: String = ""
    @objc dynamic var image: String?
     
    
    convenience init(id: Int,name: String,permalink: String,image: String?) {
        self.init()
        self.name = name
        self.id = id
        self.permalink = permalink
        self.image = image
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
}

// MARK: - Result
public final class ProductResult: Codable {
    
    var id: Int = 0
    var name: String = ""
    var permalink: String = ""
    let image: String? = nil
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case permalink
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try values.decodeIfPresent(Int.self, forKey: .id) ?? 0
        self.name = try values.decodeIfPresent(String.self, forKey: .name) ?? ""
        self.permalink = try values.decodeIfPresent(String.self, forKey: .permalink) ?? ""
    }
    
}

