//
//  RocketImageCell..swift
//  SpaceAppRx
//
//  Created by Григорий Душин on 11.05.2023.
//
import AlamofireImage
import UIKit

class RocketImageCell: UICollectionViewCell {
    @IBOutlet private var rocketImage: UIImageView!
    @IBOutlet private var rocketNameLabel: UILabel!
    @IBOutlet private var rocketView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        rocketView.layer.masksToBounds = true
        rocketView.layer.cornerRadius = 20
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        rocketImage.af.cancelImageRequest()
    }

    func setup(url: URL, rocketName: String) {
        rocketImage.af.setImage(withURL: url)
        rocketNameLabel.text = rocketName
    }
}

