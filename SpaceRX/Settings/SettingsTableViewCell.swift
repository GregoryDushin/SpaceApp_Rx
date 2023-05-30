//
//  SettingsTableViewCell.swift
//  SpaceAppRx
//
//  Created by Григорий Душин on 10.05.2023.
//

import UIKit

class SettingsTableViewCell: UITableViewCell {
    
    @IBOutlet var settingsLabel: UILabel!
    
    @IBOutlet var settingsSegmentedControl: UISegmentedControl!
    
    var onSettingChanged: ((Int) -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
        let titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        settingsSegmentedControl.setTitleTextAttributes(titleTextAttributes, for: .normal)
        let titleTextAttributes1 = [NSAttributedString.Key.foregroundColor: UIColor.black]
        settingsSegmentedControl.setTitleTextAttributes(titleTextAttributes1, for: .selected)
    }

    func cellConfigure(settings: Setting) {
        settingsSegmentedControl.selectedSegmentIndex = UserDefaults.standard.integer(forKey: settings.positionKey)
        settingsLabel.text = settings.title
        settingsSegmentedControl.setTitle(settings.values[0], forSegmentAt: 0)
        settingsSegmentedControl.setTitle(settings.values[1], forSegmentAt: 1)
        settingsSegmentedControl.addTarget(self, action: #selector(changed), for: .valueChanged)
    }

    @objc private func changed() {
        onSettingChanged?(settingsSegmentedControl.selectedSegmentIndex)
    }
}
