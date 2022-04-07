//
//  User.swift
//  Outfit Selection
//
//  Created by Evgeniy Goncharov on 04.04.2022.
//  Copyright © 2022 Denis Bystruev. All rights reserved.
//

import FirebaseAuth
import UIKit

final class User {
    // MARK: - Public Properties
    /// Public properte current User
    static let current = User()
    
    // MARK: - Stored Properties
    /// Display name
    var displayName: String
    /// User email
    var email: String
    /// The status is login
    var isLoggedIn: Bool?
    /// The number phone user
    var phone: String
    /// Url profile photo
    var photoURL: URL?
    /// Dictionary with user data
    var sequenceCredentials = ["Name:", "Email:", "Phone:"]
    /// The user's ID, unique to the Firebase project
    var uid: String?
    /// The array with user data ["Email":"example@apple.com"].
    var userCredentials = ["Name:": "", "Email:": "", "Phone:": ""] {
        didSet{
            debug(userCredentials)
        }
    }
    
    // MARK: - Init
    /// Constructor for User
    /// - Parameters:
    ///   - isLoggedIn: The status is login
    init(
        displayName: String  = "",
        email: String  = "",
        isLoggedIn: Bool?  = nil,
        phone: String  = "",
        photoURL: URL?  = nil,
        uid: String? = nil
    ) {
        self.displayName = displayName
        self.email = email
        self.isLoggedIn = isLoggedIn
        self.phone = phone
        self.photoURL = photoURL
        self.uid = uid
    }
}

