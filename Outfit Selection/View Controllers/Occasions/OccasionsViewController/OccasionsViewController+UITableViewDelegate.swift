//
//  OccasionsViewController+UITableViewDelegate.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 09.09.2021.
//  Copyright © 2021 Denis Bystruev. All rights reserved.
//

import UIKit

extension OccasionsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { OccasionCell.heigth }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        occasions[indexPath.row].isSelected.toggle()
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
}
