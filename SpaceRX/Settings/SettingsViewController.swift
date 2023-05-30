//
//  SettingsViewController.swift
//  SpaceAppRx
//
//  Created by Григорий Душин on 10.05.2023.
//

import UIKit
import RxCocoa
import RxSwift

class SettingsViewController: UIViewController {
    
    @IBOutlet var settingsTableView: UITableView!
    private let disposeBag = DisposeBag()
    private var settings = SettingsRepository()
    private var settingsArray: [Setting] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let settingsPresenter = SettingsPresenter(onUpdateSetting: { [weak self] in
            // пока хз как обновить отсюда настройки
        }, settingsRepository: settings)
        
        settingsPresenter.settingsArrayObservable
            .subscribe(onNext: { [weak self] settingsArray in
                print(settingsArray)
                self?.settingsArray = settingsArray
            })
            .disposed(by: disposeBag)
        settingsTableView.reloadData()
    }
}
extension SettingsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = settingsTableView.dequeueReusableCell(
            withIdentifier: SettingsTableViewCell.reuseIdentifier
        ) as? SettingsTableViewCell else { return UITableViewCell()
        }
        cell.cellConfigure(settings: settingsArray[indexPath.row])
        return cell
    }
}
