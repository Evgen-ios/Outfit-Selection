//
//  Wishlist+all.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 08.09.2021.
//  Copyright © 2021 Denis Bystruev. All rights reserved.
//

import Foundation

extension Wishlist {
    // MARK: - Stored Static Properties
    /// Wishlist items added by the user to the wishlist
    private static var _all: [Gender: [WishlistItem]] = [:] {
        didSet {
            guard let gender = Gender.current else { return }
            debug(_all[gender]?.count, _all[gender]?.map {( $0.gender, $0.kind, $0.name )})
        }
    }
    
    /// Wishlist items saved to user default every time they are updated
    private(set) static var all: [WishlistItem] {
        get {
            guard let gender = Gender.current else { return [] }
            return _all[gender] ?? []
        }
        set {
            guard let gender = Gender.current else { return }
            guard newValue != _all[gender] else { return }
            _all[gender] = newValue
            save()
        }
    }
    
    static func append(_ wishlistItem: WishlistItem) {
        all.append(wishlistItem)
    }
    
    /// Clear both items and outfit wishlists
    static func removeAll(where shouldBeRemoved: (WishlistItem) -> Bool) {
        all.removeAll(where: shouldBeRemoved)
    }
}


// MARK: - User Defaults
extension Wishlist {
    // MARK: - Static Constants
    /// User defaults key
    static let userDefaultsKey = "GetOutfitWishlistKey"
    
    // MARK: - Methods
    /// Load wishlist from user defaults
    static func load() {
        guard let data = UserDefaults.standard.object(forKey: userDefaultsKey) as? Data else {
            debug("WARNING: Can't find data from user defaults for key \(userDefaultsKey)")
            return
        }
        
        guard let wishlistItems = try? PList.decoder.decode([Gender: [WishlistItem]].self, from: data) else {
            debug("WARNING: Can't decode \(data) from user defaults to [WishlistItem] for key \(userDefaultsKey)")
            return
            
        }
        
        _all = wishlistItems
    }
    
    /// Save wishlist to user defaults
    static func save() {
        guard let data = try? PList.encoder.encode(_all) else {
            debug("WARNING: Can't encode \(all.count) wishlist items for key \(userDefaultsKey)")
            return
        }
        
        UserDefaults.standard.set(data, forKey: userDefaultsKey)
    }
}
