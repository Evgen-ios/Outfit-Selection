//
//  Item.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 26.10.2020.
//  Copyright © 2020 Denis Bystruev. All rights reserved.
//

import Foundation

final class Item: Decodable, Encodable {
    // MARK: - Static Properties
    /// All items loaded from the server
    private(set) static var all = [String: Item]()
    
    /// The maximum number of items for one outfit corner
    static let maxCount = 100
    
    // MARK: - Static Methods
    /// Appends items to Item.all. Mimics generic collection's method append(contentsOf:) while saving current index in itemIndex property of each item
    /// - Parameter newItems: collection of new items to be added to the Item.all
    static func append(contentsOf newItems: [Item]) {
        newItems.forEach { all[$0.id] = $0 }
    }
    
    /// Dislikes given item in Item.all
    /// - Parameter item: the item to be disliked
    static func dislike(_ item: Item?) {
        item?.disliked = true
    }
    
    /// Clears all items
    static func removeAll() {
        all.removeAll()
    }
    
    /// Update all items vendor names to full versions
    /// - Parameter fullVendorNames: the dictionary with short : full vendor names
    static func updateVendorNames(with fullVendorNames: [String: String]) {
        all.forEach { $0.value.updateVendorName(with: fullVendorNames) }
    }
    
    // MARK: - Stored Properties
    /// Item's color
    let color: String
    
    /// Item's id
    let id: String
    
    /// Item's category id
    let categoryId: Int
    
    /// Whether an item has been disliked
    var disliked = false
    
    /// Item's gender
    let gender: Gender
    
    /// Date and time when offer was last modified
    var modifiedTime: Date
    
    /// Item's name
    let name: String
    
    /// The item's previous price
    let oldPrice: Double?
    
    /// The collection of URLs to load item images from
    let pictures: [URL]
    
    /// The item's current price
    let price: Double
    
    /// Item's size
    let size: String
    
    /// The item URL to purchase
    let url: URL
    
    /// The item vendor
    var vendorName: String

    /// True if item is in any wishlist, false otherwise (default)
    var wishlisted = false
    
    enum CodingKeys: String, CodingKey {
        case categoryId = "category_id"
        case color
        case gender
        case id
        case modifiedTime = "modified_time"
        case name
        case oldPrice = "old_price"
        case pictures
        case price
        case size
        case url
        case vendorName = "vendor"
    }
    
    // MARK: - Computed Properties
    var modifiedTimestamp: String {
        get { Timestamp.formatter.string(from: modifiedTime) }
        set {
            guard let newTime = Timestamp.formatter.date(from: newValue) else { return }
            modifiedTime = newTime
        }
    }
    
    /// If item name starts with vendor (brand) drop that brand and capitalize the first letter of remaining string
    var nameWithoutVendor: String? {
        let lowercasedName = name.lowercased()
        guard lowercasedName.starts(with: vendorName.lowercased()) else { return lowercasedName }
        return lowercasedName.dropFirst(vendorName.count).trimmingCharacters(in: .whitespacesAndNewlines).capitalizingFirstLetter
    }
    
    /// Non-optional time for sorting operations
    var time: TimeInterval { modifiedTime.timeIntervalSinceReferenceDate }
    
    // MARK: - Decodable
    init(from decoder: Decoder) throws {
        // Get values from the container
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        // Decode each of the properties
        categoryId = try values.decode(Int.self, forKey: .categoryId)
        color = try values.decode(String.self, forKey: .color)
        gender = try values.decode(Gender.self, forKey: .gender)
        id = try values.decode(String.self, forKey: .id)
        let modifiedTimestamp = try values.decode(String.self, forKey: .modifiedTime)
        modifiedTime = Timestamp.formatter.date(from: modifiedTimestamp) ?? Date()
        name = try values.decode(String.self, forKey: .name)
        oldPrice = try? values.decode(Double.self, forKey: .oldPrice)
        pictures = try values.decode([URL].self, forKey: .pictures)
        price = try values.decode(Double.self, forKey: .price)
        size = try values.decode(String.self, forKey: .size)
        url = try values.decode(URL.self, forKey: .url)
        vendorName = try values.decode(String.self, forKey: .vendorName)
    }
    
    // MARK: - Methods
    /// Set item's wishlist property to true or false
    /// - Parameter value: the value to set the wishlist property to, true by default
    func setWishlisted(to value: Bool = true) {
        wishlisted = value
    }
    
    /// Check if current vendor name is found in full vendor names dictionary and update it if so
    /// - Parameter fullVendorNames: the dictionary with short : full vendor names
    func updateVendorName(with fullVendorNames: [String: String]) {
        vendorName = fullVendorNames[vendorName] ?? vendorName
    }
}
