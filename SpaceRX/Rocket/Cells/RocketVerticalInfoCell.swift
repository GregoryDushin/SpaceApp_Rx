//
//  RocketVerticalInfoCell.swift
//  SpaceAppRx
//
//  Created by Григорий Душин on 11.05.2023.
//

import UIKit

class RocketVerticalInfoCell: UICollectionViewCell {
    @IBOutlet private var nameSettingsLabel: UILabel!
    @IBOutlet private var valueSettingsLabel: UILabel!

    func setup(title: String, value: String) {
        nameSettingsLabel.text = title
        valueSettingsLabel.text = value
    }
}
