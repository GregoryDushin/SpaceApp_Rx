//
//  LaunchPresenter.swift
//  SpaceApp
//
//  Created by Григорий Душин on 29.11.2022.
//

import UIKit
import RxCocoa
import RxSwift

final class LaunchViewModel {
    private let launchLoader = LaunchLoader()
    private let id: String
    private let disposeBag = DisposeBag()
    private let errorRelay = PublishRelay<String>()
    private let lastErrorSubject: Observable<String>
    private let launchRelay = PublishRelay<[LaunchData]>()
    private let lastLaunchArraySubject: Observable<[LaunchData]>

    private let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/YY"
        return dateFormatter
    }()

    var errorDriver: Driver<String> {
        lastErrorSubject.asDriver(onErrorJustReturn: "")
    }

    var launchArrayDriver: Driver<[LaunchData]> {
        lastLaunchArraySubject.asDriver(onErrorJustReturn: [])
    }

    required init(id: String) {
        self.id = id
        self.lastErrorSubject = errorRelay
            .asObservable()
            .share(replay: 1)
        self.lastLaunchArraySubject = launchRelay
            .asObservable()
            .share(replay: 1)
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
                    self?.errorRelay.accept(errorMessage)
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

        launchRelay.accept(data)
    }
}
