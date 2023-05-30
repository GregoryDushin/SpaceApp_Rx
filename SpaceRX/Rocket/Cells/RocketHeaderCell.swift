//
//  RocketHeaderCell.swift
//  SpaceAppRx
//
//  Created by Григорий Душин on 11.05.2023.
//

import UIKit

class RocketHeaderCell: UICollectionViewCell {
    @IBOutlet private var headerLabel: UILabel!

    func setup(title: String) {
        headerLabel.text = title
    }
}
