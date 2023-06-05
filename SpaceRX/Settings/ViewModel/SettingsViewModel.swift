//
//  SettingsViewModel.swift
//  SpaceAppRx
//
//  Created by Григорий Душин on 10.05.2023.
//

import Foundation
import RxCocoa
import RxSwift

final class SettingsViewModel {

    private let defaults = UserDefaults.standard
    private let onUpdateSetting: (() -> Void)
    private let settingsRepository: SettingsRepositoryProtocol
    var settingsArray: Driver<[Setting]>!

    init(onUpdateSetting: @escaping (() -> Void), settingsRepository: SettingsRepositoryProtocol) {
        self.onUpdateSetting = onUpdateSetting
        self.settingsRepository = settingsRepository
        self.settingsArray = Driver.just(configureSettingsArray())
    }

    private func configureSettingsArray() -> [Setting] {
        let settingsArrayValue = [
            Setting(
                title: "Высота",
                positionKey: PersistancePositionKeys.heightPositionKey,
                values: ["m", "ft"]
            ),
            Setting(
                title: "Диаметр",
                positionKey: PersistancePositionKeys.diameterPositionKey,
                values: ["m", "ft"]
            ),
            Setting(
                title: "Масса",
                positionKey: PersistancePositionKeys.massPositionKey,
                values: ["kg", "lb"]
            ),
            Setting(
                title: "Полезная нагрузка",
                positionKey: PersistancePositionKeys.capacityPositionKey,
                values: ["kg", "lb"]
            )
        ]
        return settingsArrayValue
    }

    func saveData(selectedIndex: Int, indexPath: Int) {
        settingsRepository.set(setting: configureSettingsArray()[indexPath].positionKey, value: String(selectedIndex))
        onUpdateSetting()
    }
}
