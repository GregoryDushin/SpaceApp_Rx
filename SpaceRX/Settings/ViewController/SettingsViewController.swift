//
//  SettingsViewController.swift
//  SpaceAppRx
//
//  Created by Григорий Душин on 10.05.2023.
//

import UIKit
import RxCocoa
import RxSwift

final class SettingsViewController: UIViewController {

    @IBOutlet private var settingsTableView: UITableView!
    private let disposeBag = DisposeBag()
    private var settings = SettingsRepository()
    private var settingsArray: [Setting] = []
    private var viewModel: SettingsViewModel!

    init?(coder: NSCoder, viewModel: SettingsViewModel) {
        self.viewModel = viewModel
        super.init(coder: coder)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        preconditionFailure("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.settingsArray?
            .drive(onNext: { [weak self] settingsArray in
                self?.settingsArray = settingsArray
            })
            .disposed(by: disposeBag)
    }
}
extension SettingsViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        settingsArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = settingsTableView.dequeueReusableCell(
            withIdentifier: SettingsTableViewCell.reuseIdentifier
        ) as? SettingsTableViewCell else { return UITableViewCell()
        }
        cell.cellConfigure(settings: settingsArray[indexPath.row])
        cell.onSettingChanged = { [weak self] selectedIndex in
            self?.viewModel.saveData(selectedIndex: selectedIndex, indexPath: indexPath.row)
        }
        return cell
    }
}
