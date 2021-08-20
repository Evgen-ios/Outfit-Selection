//
//  FeedCell.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 20.08.2021.
//  Copyright © 2021 Denis Bystruev. All rights reserved.
//

import UIKit

class FeedCell: UITableViewCell {
    // MARK: - Outlets
    @IBOutlet weak var itemStackView: UIStackView!
    @IBOutlet weak var seeAllButton: DelegatedButton!
    @IBOutlet weak var titleLabel: UILabel!
    
    // MARK: - Class Properties
    class var identifier: String { nib }
    class var nib: String { String(describing: Self.self) }
    
    // MARK: - Static Constants
    /// Default cell's height
    static let height: CGFloat = 250
    
    // MARK: - Stored Properties
    /// Delegate to call when see all button is tapped
    var delegate: ButtonDelegate?

    // MARK: - Class Methods
    /// Registers the cell with the table view
    /// - Parameter tableView: the table view to register with
    /// - Returns: (optional) returns cell identifier, also available as MessageListCell.identifier
    @discardableResult class func register(with tableView: UITableView?) -> String {
        let aNib = UINib(nibName: nib, bundle: nil)
        tableView?.register(aNib, forCellReuseIdentifier: identifier)
        return identifier
    }
    
    // MARK: - Methods
    override func awakeFromNib() {
        super.awakeFromNib()
        configureLayout()
    }
    
    func configureLayout() {
        debug("itemStackView.arrangedSubviews.count =", itemStackView.arrangedSubviews.count)
    }
    
    // MARK: - Actions
    @IBAction func seeAllButtonTapped(_ sender: DelegatedButton) {
        delegate?.buttonTapped(sender)
    }
}
