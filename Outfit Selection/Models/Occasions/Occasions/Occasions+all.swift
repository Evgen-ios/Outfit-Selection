//
//  Occasions+all.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 09.09.2021.
//  Copyright © 2021 Denis Bystruev. All rights reserved.
//

import Foundation

extension Occasions {
    
    // MARK: - Static Stored Properties
    /// All occasions by ID, not selected by default
    private(set) static var byID: [Int: Occasion] = [:]
    
    /// All occasions by title
    private(set) static var byTitle: [String: Occasions] = [:]
    
    // MARK: - Static Computed Properties
    /// The set of labels of all occasions
    static var labels: Set<String> { Set(byID.values.map({ $0.label }))}
    
    /// The set of names of all occasions
    static var names: Set<String> { Set(byID.values.map({ $0.name }))}
    
    /// The list of selected occasions
    static var selected: Occasions { byID.values.filter { $0.isSelected }}
    
    /// The list of selected occasions with unique title
    static var selectedUniqueTitle: Occasions { selectedTitles.compactMap { byTitle[$0]?.first }}
    
    /// The ids of selected occasions
    static var selectedIDs: [Int] { selected.map { $0.id }}
    
    /// The ids of selected occasions with unique title
    static var selectedIDsUniqueTitle: [Int] { selectedUniqueTitle.map { $0.id }}
    
    /// The set of labels of selected occasions
    static var selectedLabels: Set<String> { Set(selected.map { $0.label })}
    
    /// The set of names of selected occasions
    static var selectedNames: Set<String> { Set(selected.map { $0.name })}
    
    /// The set of titles (name: label) of selected occasions
    static var selectedTitles: Set<String> { Set(selected.map { $0.title })}
    
    /// The set of titles (name: label) of all occasions
    static var titles: Set<String> { Set(byID.values.map { $0.title })}
    
    /// The list of unselected occasions
    static var unselected: Occasions { byID.values.filter { !$0.isSelected }}
    
    // MARK: - Static Methods
    /// Append given occasion to `byId` and `byTitle`
    /// - Parameter occasion: occasion to add
    static func append(_ occasion: Occasion) {
        // MARK: TODO Ensure unique look categories
        byID[occasion.id] = occasion
        
        // Update occasions by title
        byTitle[occasion.title] = with(title: occasion.title)
    }
    
    /// Clears all occasions dictionary
    static func removeAll() {
        byID.removeAll()
        byTitle.removeAll()
    }
    
    /// Select/deselect all occasions with given title
    /// - Parameters:
    ///   - title: the title to search for
    ///   - shouldSelect: true to select, false to unselect
    static func select(title: String, shouldSelect: Bool) {
        with(title: title).forEach { $0.isSelected = shouldSelect }
    }
    
    /// Update all occasions with given gender
    /// - Parameter gender: the gender to update occasions with
    static func updateWith(gender: Gender?) {
        // Don't update if gender is not set or is set to unisex
        guard let gender = gender, gender != .other else { return }
        
        // Remove all occasions with different gender
        byID.values
            .filter { $0.gender != gender }
            .forEach { byID[$0.id] = nil }
    }
    
    /// Return all occasions with given title
    /// - Parameter title: the title to look for
    /// - Returns: the list of occasions with the title
    static func with(title: String) -> Occasions {
        byID.values.filter { $0.title == title }
    }
}