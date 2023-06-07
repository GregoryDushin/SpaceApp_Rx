//
//  LaunchPresenter.swift
//  SpaceApp
//
//  Created by Григорий Душин on 29.11.2022.
//

import UIKit
import RxSwift
import RxCocoa

final class LaunchViewModel {
    private let launchLoader = LaunchLoader()
    private let id: String
    private let disposeBag = DisposeBag()
    private let launchArray = BehaviorRelay<[LaunchData]>(value: [])
    private let errorSubject = BehaviorRelay<String>(value: "")

    var errorDriver: Driver<String> {
        errorSubject.asDriver()
    }

    var launchArrayDriver: Driver<[LaunchData]> {
        launchArray.asDriver()
    }

    private let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/YY"
        return dateFormatter
    }()

    required init(id: String) {
        self.id = id
        getData()
    }

    func getData() {
        launchLoader.loadLaunchData(id: id)
            .observe(on: MainScheduler.instance)
            .subscribe(
                onSuccess: { [weak self] launches in
                    self?.transferDataIntoLaunchVC(launches)
                },
                onFailure: { [weak self] error in
                    let errorMessage = error.localizedDescription
                    self?.errorSubject.accept(errorMessage)
                }
            )
            .disposed(by: disposeBag)
    }
    private func transferDataIntoLaunchVC(_ launchModel: [LaunchModelElement]) {

        let data: [LaunchData] = launchModel.map {
            let launchImage: UIImage

            if let launchingResult = $0.success {
                launchImage = UIImage.named( (launchingResult ? LaunchImages.success : LaunchImages.unsucsess))
            } else {
                launchImage = UIImage.named(LaunchImages.unknown)
            }

            let launchData = LaunchData(
                name: $0.name,
                date: dateFormatter.string(from: $0.dateUtc),
                image: launchImage
            )
            return launchData
        }

        launchArray.accept(data)
    }
}
