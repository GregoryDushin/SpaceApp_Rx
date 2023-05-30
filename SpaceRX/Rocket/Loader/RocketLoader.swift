//
//  RocketLoader.swift
//  SpaceX
//
//  Created by Григорий Душин on 06.10.2022.
//

import UIKit
import RxCocoa
import RxSwift

// MARK: - JSON ROCKET PARSING

final class RocketLoader {
    private let decoder = JSONDecoder()
    private let session: URLSession
    
    init(urlSession: URLSession = .shared) {
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        self.session = urlSession
    }
    
    func loadRocketData() -> Single<[RocketModelElement]> {
        guard let url = URL(string: Url.rocketUrl) else {
            return .error(NSError(domain: "Invalid URL", code: -1, userInfo: nil))
        }
        
        let request = URLRequest(url: url)
        return URLSession.shared.rx.response(request: request)
            .map { response, data -> [RocketModelElement] in
                do {
                    let json = try self.decoder.decode([RocketModelElement].self, from: data)
                    return json
                } catch {
                    throw error
                }
            }
            .asSingle()
    }
}
