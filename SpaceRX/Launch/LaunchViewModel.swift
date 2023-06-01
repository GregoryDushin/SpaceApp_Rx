//
//  LaunchPresenter.swift
//  SpaceApp
//
//  Created by Григорий Душин on 29.11.2022.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

final class LaunchViewModel {
    private let launchLoader = LaunchLoader()
    private let id: String
    private let disposeBag = DisposeBag()
    private let launchArray = BehaviorRelay<[LaunchData]>(value: [])
    private let errorSubject = PublishSubject<String>()

    var errorObservable: Observable<String> {
        errorSubject.asObservable()
    }

    var launchArrayObservable: Observable<[LaunchData]> {
        launchArray.asObservable()
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
        .subscribe( onSuccess: { launches in
            self.transferDataIntoLaunchVC(launches)
        }, onFailure: { error in
            self.handleError(error)
        })
        .disposed(by: disposeBag)
}

    private func handleError(_ error: Error) {
            let errorMessage = error.localizedDescription
            errorSubject.onNext(errorMessage)
        }

    private func transferDataIntoLaunchVC(_ launchModel: [LaunchModelElement]) {
        var data = [LaunchData]()

        launchModel.map {
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
            data.append(launchData)
        }
        launchArray.accept(data)
    }
}
