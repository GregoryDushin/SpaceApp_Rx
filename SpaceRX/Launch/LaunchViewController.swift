//
//  LaunchViewController.swift
//  SpaceAppRx
//
//  Created by Григорий Душин on 10.05.2023.
//

import UIKit
import RxSwift
import RxCocoa

final class LaunchViewController: UIViewController {
    @IBOutlet private var launchCollectionView: UICollectionView!

    private var launches: [LaunchData] = []
    private var viewModel: LaunchViewModel
    private let launchLoader = LaunchLoader()
    private let disposeBag = DisposeBag()

    init?(coder: NSCoder, viewModel: LaunchViewModel) {
        self.viewModel = viewModel
        super.init(coder: coder)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        preconditionFailure("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.errorDriver
            .drive(onNext: { [weak self] errorMessage in
                self?.showAlert(errorMessage)
            }
            )
            .disposed(by: disposeBag)

        viewModel.launchArrayDriver
            .drive(onNext: { [weak self] launchArray in
                self?.launches = launchArray
                self?.launchCollectionView.reloadData()
            }
            )
            .disposed(by: disposeBag)
    }

    private func showAlert(_ error: String) {
        let alert = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
        self.present(alert, animated: true)
    }
}

// MARK: - CollectionViewDelegateFlowLayout

extension LaunchViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let widthCell = UIScreen.main.bounds.width - 40
        return CGSize(width: widthCell, height: 100)
    }

    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        launches.count
    }
}

// MARK: - Collection View Data Source

extension LaunchViewController: UICollectionViewDataSource {

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath:
        IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: LaunchCell.reuseIdentifier,
            for: indexPath
        ) as? LaunchCell else { return UICollectionViewCell() }

        cell.configure(launchData: launches[indexPath.row])
        return cell
    }
}
