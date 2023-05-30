//
//  SettingsViewModel.swift
//  SpaceAppRx
//
//  Created by Григорий Душин on 10.05.2023.
//

import Foundation
import RxSwift
import RxCocoa


final class SettingsPresenter {
    
    private let defaults = UserDefaults.standard
    private let onUpdateSetting: (() -> Void)
    private let settingsRepository: SettingsRepositoryProtocol
    private let settingsArray = BehaviorRelay<[Setting]>(value: [])
    
    var settingsArrayObservable: Observable<[Setting]> {
        return settingsArray.asObservable()
    }
    
    private func configureSettingsArray() {
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
        settingsArray.accept(settingsArrayValue)
    }
    
    init(onUpdateSetting: @escaping (() -> Void), settingsRepository: SettingsRepositoryProtocol) {
        self.onUpdateSetting = onUpdateSetting
        self.settingsRepository = settingsRepository
        configureSettingsArray()
    }
    
    func saveData(selectedIndex: Int, indexPath: Int) {
        settingsRepository.set(setting: settingsArray.value[indexPath].positionKey, value: String(selectedIndex))
        onUpdateSetting()
    }
}
