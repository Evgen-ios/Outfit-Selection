//
//  Item+Branded.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 14.12.2020.
//  Copyright © 2020 Denis Bystruev. All rights reserved.
//

// MARK: - Branded
extension Item: Branded {
    var brand: String? { vendorName }
}
