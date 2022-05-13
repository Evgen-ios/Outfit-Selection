//
//  Users.swift
//  Outfit Selection
//
//  Created by Evgeniy Goncharov on 13.05.2022.
//  Copyright © 2022 Denis Bystruev. All rights reserved.
//

import Foundation

typealias Users = [User]

extension Users {
    // MARK: - Static Stored Properties
    /// All users as received from the server
    static var all: [User] = []
    
    // MARK: - Static Methods
    /// Append given user
    /// - Parameter user: user to add
    static func append(_ user: User) {
        // Update server users
        all.append(user)
    }
}
