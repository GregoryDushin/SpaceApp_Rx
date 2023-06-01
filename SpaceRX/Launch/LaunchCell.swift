//
//  CollectionViewCell.swift
//  SpaceX
//
//  Created by Григорий Душин on 09.10.2022.
//

import UIKit
final class LaunchCell: UICollectionViewCell {
    @IBOutlet private var rocketNameLabel: UILabel!
    @IBOutlet private var dateOfLaunchLabel: UILabel!
    @IBOutlet private var isSucsessImage: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        layer.masksToBounds = true
        layer.cornerRadius = 12
    }

    func configure(launchData: LaunchData) {
        rocketNameLabel.text = launchData.name
        dateOfLaunchLabel.text = launchData.date
        isSucsessImage.image = launchData.image
    }
}
