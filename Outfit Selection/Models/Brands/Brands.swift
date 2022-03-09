//
//  Brands.swift
//  Outfit Selection
//
//  Created by Evgeniy Goncharov on 03.03.2022.
//  Copyright © 2022 Denis Bystruev. All rights reserved.
//

import Algorithms

typealias Brands = [String: Brand]

extension Brands {
    // MARK: - Computed Properties
    /// Brands filtered by filter
    var filtered: Brands {
        let filterString = Brands.filterString.lowercased()
        if filterString.isEmpty { return self }
        return filter { $0.value.name.lowercased().contains(filterString) }
    }
    
    /// Unique brand names
    var names: [String] { map { $0.value.name }.sorted() }
    
    /// Sortered array with brand, first brands with image, after sortered without image
    var sorted: [Brand] {
        // Brands with logos and sorted it by name
        withImage.map({ $0.value }).sorted() +
        
        // Brands without logos and sorted it by name
        withoutImage.map({ $0.value }).sorted()
    }
    
    /// All selected brands
    var selected: Brands { filter { $0.value.isSelected } }
    
    /// All unselected brands
    var unselected: Brands { filter { !$0.value.isSelected } }
    
    /// All branded images sorted by selected first
    //var prioritizeSelected: Brands { selected + unselected }
    
    /// All brands with logo image
    var withImage: Brands { filter { $0.value.image != nil } }
    
    /// All brands with logo image
    var withoutImage: Brands { filter { $0.value.image == nil } }
    
    // MARK: - Static Computed Properties
    /// Filter brand names by this string
    static var filterString = ""
    
    /// Brands filtered by filter string
    static var filtered: Brands { byName.filtered }
    
    /// Last selected branded image
    static var lastSelected: Bool?
    
    /// Filter brand names by this string
    static var names: [String] { byName.names }
    
    /// Sortered array with brand, first brands with image, after sortered without image
    static var sorted: [Brand] { byName.sorted }
    
    /// All selected brands
    static var selected: Brands { byName.selected }
    
    /// All unselected brands
    static var unselected: Brands { byName.unselected }
    
    /// All brands with logo image
    static var withImage: Brands { byName.withImage }
    
    /// All brands with logo image
    static var withoutImage: Brands { byName.withoutImage }

}