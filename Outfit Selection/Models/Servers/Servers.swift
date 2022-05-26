//
//  Servers.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 01.05.2022.
//  Copyright © 2022 Denis Bystruev. All rights reserved.
//

import Foundation

public typealias Servers = [Server]

extension Servers {
    /// All available servers
    public static let all: Servers = [
        Server(
            about: "Oracle Cloud Amsterdam ",
            id: 1,
            name: "oracle.getoutfit.net",
            shouldUse: true,
            url: URL(string: "http://oracle.getoutfit.net:3000")!
        ), Server(
            about: "Oracle Cloud Frankfurt ",
            id: 2,
            name: "oracle.getoutfit.co",
            shouldUse: true,
            url: URL(string: "http://oracle.getoutfit.co:3000")!
        ),
    ]
}
