//
//  RocketLaunchButtonCell.swift
//  SpaceAppRx
//
//  Created by Григорий Душин on 11.05.2023.
//

import UIKit

class RocketLaunchButtonCell: UICollectionViewCell {
    @IBOutlet private var launchButton: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        launchButton.layer.masksToBounds = true
        launchButton.layer.cornerRadius = 20
    }
}
