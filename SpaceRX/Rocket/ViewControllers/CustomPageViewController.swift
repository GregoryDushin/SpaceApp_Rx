//
//  CustomPageViewController.swift
//  SpaceAppRx
//
//  Created by Григорий Душин on 10.05.2023.
//

import UIKit
import RxCocoa
import RxSwift

 class CustomPageViewController: UIPageViewController {

    private var currentViewControllerIndex = 0
    var rockets: [RocketModelElement] = []
    private let rocketLoader = RocketLoader()
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        delegate = self

        rocketLoader.loadRocketData()
            .observe(on: MainScheduler.instance)
            .subscribe( onSuccess: { rockets in
                self.rockets = rockets
                self.configureStartingVC()
            }, onFailure: { error in
                self.showAlert(error.localizedDescription)
            })
            .disposed(by: disposeBag)
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    private func configureStartingVC() {
        guard let startingViewController = passViewControllerAt(index: currentViewControllerIndex) else {
            return
        }
            setViewControllers([startingViewController], direction: .forward, animated: true)
    }

    private func passViewControllerAt(index: Int) -> RocketViewController? {
        guard let dataViewController =
                storyboard?.instantiateViewController(
                    withIdentifier: String(
                        describing: RocketViewController.self
                    )
                ) as? RocketViewController, index <= rockets.count, !rockets.isEmpty else {
            return nil
        }

        dataViewController.rocketData = rockets[index]
        dataViewController.index = index
        dataViewController.id = rockets[index].id
        return dataViewController
    }

    private func showAlert(_ error: String) {
        let alert = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
        self.present(alert, animated: true)
    }
}

// MARK: - UIPageViewDataSource

extension CustomPageViewController: UIPageViewControllerDataSource {

    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerBefore viewController: UIViewController
    ) -> UIViewController? {
        let dataViewController = viewController as? RocketViewController
        guard var currentIndex = dataViewController?.index else {
            return nil
        }

        currentViewControllerIndex = currentIndex
        if currentIndex == 0 {
            return nil
        }

        currentIndex -= 1
        return passViewControllerAt(index: currentIndex)
    }

    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerAfter viewController: UIViewController
    ) -> UIViewController? {
        let dataViewController = viewController as? RocketViewController
        guard var currentIndex = dataViewController?.index else {
            return nil
        }

        if currentIndex == rockets.count - 1 {
            return nil
        }

        currentIndex += 1
        currentViewControllerIndex = currentIndex
        return passViewControllerAt(index: currentIndex)
    }
}

// MARK: - UIPageViewControllerDelegate

extension CustomPageViewController: UIPageViewControllerDelegate {
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        currentViewControllerIndex
    }

    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        rockets.count
    }
}
