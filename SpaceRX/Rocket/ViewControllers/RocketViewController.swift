//
//  ViewController.swift
//  SpaceAppRx
//
//  Created by Григорий Душин on 05.05.2023.
//

import UIKit
import RxCocoa
import RxSwift

final class RocketViewController: UIViewController {
    
    @IBOutlet var collectionView: UICollectionView!
    
    
    typealias DataSource = UICollectionViewDiffableDataSource<Section, ListItem>
    typealias DataSourceSnapshot = NSDiffableDataSourceSnapshot<Section, ListItem>

    private let settings = SettingsRepository()
    private let disposeBag = DisposeBag()
    private lazy var dataSource = configureCollectionViewDataSource()
    private var snapshot = DataSourceSnapshot()
    var index: Int = 0
    var id = ""
    var rocketData: RocketModelElement!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("hui rocket")
        let viewModel = RocketViewModel(rocketData: rocketData, settingsRepository: SettingsRepository())
        viewModel.settingsUpdated.accept(())
        viewModel.sectionsObservable
            .drive(onNext: { sections in
                self.present(data: sections)
                print(sections)
            }
            )
            .disposed(by: disposeBag)
        
        collectionView.collectionViewLayout = createLayout()
        configureHeader()
    }

    // MARK: - Configure CollectionView DataSource

    private func configureCollectionViewDataSource() -> DataSource {
        dataSource = DataSource(
            collectionView: collectionView) { collectionView, indexPath, listItem -> UICollectionViewCell? in
                switch listItem {
                case let .image(url, rocketName):
                    guard let cell = collectionView.dequeueReusableCell(
                        withReuseIdentifier: RocketImageCell.reuseIdentifier,
                        for: indexPath
                    ) as? RocketImageCell else { return UICollectionViewCell() }

                    cell.setup(url: url, rocketName: rocketName)
                    return cell
                case let .horizontalInfo(title, value):
                    guard let cell = collectionView.dequeueReusableCell(
                        withReuseIdentifier: RocketHorizontalInfoCell.reuseIdentifier,
                        for: indexPath
                    ) as? RocketHorizontalInfoCell else { return UICollectionViewCell() }

                    cell.setup(title: title, value: value)
                    return cell
                case let .verticalInfo(title, value, _):
                    guard let cell = collectionView.dequeueReusableCell(
                        withReuseIdentifier: RocketVerticalInfoCell.reuseIdentifier,
                        for: indexPath
                    ) as? RocketVerticalInfoCell else { return UICollectionViewCell() }

                    cell.setup(title: title, value: value)
                    return cell
                case .button:
                    guard let cell = collectionView.dequeueReusableCell(
                        withReuseIdentifier: RocketLaunchButtonCell.reuseIdentifier,
                        for: indexPath
                    ) as? RocketLaunchButtonCell else { return UICollectionViewCell() }

                    return cell
                }
            }

        return dataSource
    }

    func present(data: [Section]) {
        var snapshot = DataSourceSnapshot()
        snapshot = DataSourceSnapshot()
        for section in data {
            snapshot.appendSections([section])
            snapshot.appendItems(section.items, toSection: section)
        }
        
        dataSource.apply(snapshot)
    }

    private func configureHeader() {
        dataSource.supplementaryViewProvider = { collectionView, kind, indexPath -> UICollectionReusableView? in
            guard let header = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: RocketHeaderCell.reuseIdentifier,
                for: indexPath
            ) as? RocketHeaderCell else { return UICollectionReusableView()
            }
            header.setup(title: self.dataSource.snapshot().sectionIdentifiers[indexPath.section].title ?? "")
            return header
        }
    }

    // MARK: - Creating sections using CompositionalLayout

    private func createLayout() -> UICollectionViewCompositionalLayout {
        UICollectionViewCompositionalLayout { [weak self] sectionIndex, _ in
            guard let self = self else { return nil }

            let section = self.dataSource.snapshot().sectionIdentifiers[sectionIndex].sectionType
            switch section {
            case .image:
                let item = NSCollectionLayoutItem(
                    layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
                )
                let group = NSCollectionLayoutGroup.horizontal(
                    layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(0.6)), subitems: [item]
                )
                return NSCollectionLayoutSection(group: group)
            case .horizontal:
                let item = NSCollectionLayoutItem(
                    layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
                )
                let group = NSCollectionLayoutGroup.horizontal(
                    layoutSize: .init(widthDimension: .absolute(150), heightDimension: .absolute(150)), subitems: [item]
                )
                let section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .continuous
                section.interGroupSpacing = 5
                section.contentInsets = .init(top: 5, leading: 5, bottom: 5, trailing: 5)
                return section
            case .vertical:
                let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(60)))
                let group = NSCollectionLayoutGroup.vertical(
                    layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(130)), subitems: [item]
                )
                let section = NSCollectionLayoutSection(group: group)
                let headerFooterSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(44))
                let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
                    layoutSize: headerFooterSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top
                )
                section.boundarySupplementaryItems = [sectionHeader]
                return section
            case .button:
                let item = NSCollectionLayoutItem(
                    layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
                )
                let group = NSCollectionLayoutGroup.horizontal(
                    layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(90)), subitems: [item]
                )
                return NSCollectionLayoutSection(group: group)
            }
        }
    }

//    // MARK: - Data transfer between View Controllers
//
//    @IBSegueAction
//    func transferLaunchInfo(_ coder: NSCoder) -> LaunchViewController? {
//        let presenter = LaunchPresenter(launchLoader: LaunchLoader(), id: id)
//
//        return LaunchViewController(coder: coder, presenter: presenter)
//    }
//
//    @IBSegueAction
//    func transferSettingsInfo(_ coder: NSCoder) -> SettingsViewController? {
//        let presenter = SettingsPresenter(onUpdateSetting: { [weak self] in
//            guard let self = self else { return }
//            self.presenter.getData() }, settingsRepository: settings)
//
//        return SettingsViewController(coder: coder, presenter: presenter)
//    }
}

//extension RocketViewController: RocketViewProtocol {
//    func present(data: [Section]) {
//        var snapshot = DataSourceSnapshot()
//        snapshot = DataSourceSnapshot()
//        for section in data {
//            snapshot.appendSections([section])
//            snapshot.appendItems(section.items, toSection: section)
//        }
//
//        dataSource.apply(snapshot)
//    }
//}
