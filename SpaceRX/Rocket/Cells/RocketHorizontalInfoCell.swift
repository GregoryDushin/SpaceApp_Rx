//
//  RocketHorizontalInfoCell.swift
//  SpaceAppRx
//
//  Created by Григорий Душин on 11.05.2023.
//

import UIKit

class RocketHorizontalInfoCell: UICollectionViewCell {
    @IBOutlet private var mainParametrLabel: UILabel!
    @IBOutlet private var valueParametrLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        layer.masksToBounds = true
        layer.cornerRadius = 60
    }

    func setup(title: String, value: String) {
        mainParametrLabel.text = title
        valueParametrLabel.text = value
    }
}
