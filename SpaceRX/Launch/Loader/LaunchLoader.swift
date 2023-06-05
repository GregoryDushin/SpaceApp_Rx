//
//  LaunchLoaderViewController.swift
//  SpaceAppRx
//
//  Created by Григорий Душин on 08.05.2023.
//

import UIKit
import RxCocoa
import RxSwift

// MARK: - JSON lAUNCH PARSING

final class LaunchLoader {

    private let decoder = JSONDecoder()
    private let session: URLSession

    init(urlSession: URLSession = .shared) {
        let dateFormatter = DateFormatter()
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        self.session = urlSession
    }

    func loadLaunchData(id: String) -> Single<[LaunchModelElement]> {
        guard let url = URL(string: Url.launchUrl) else {
            return .error(NSError(domain: "InvalidURL", code: 0, userInfo: nil))
        }

        let request = URLRequest(url: url)
        return session.rx.data(request: request)
            .map { data -> [LaunchModelElement] in
                do {
                    let json = try self.decoder.decode([LaunchModelElement].self, from: data)
                    return json.filter { $0.rocket == id }
                } catch {
                    throw error
                }
            }

            .asSingle()
    }
}
