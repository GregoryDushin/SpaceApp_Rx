import Foundation

// MARK: - CodableRocketModel

struct RocketModelElement: Decodable, Equatable {
    let height: Diameter
    let diameter: Diameter
    let mass: Mass
    let firstStage: FirstStage
    let secondStage: SecondStage
    let payloadWeights: [PayloadWeight]
    let flickrImages: [String]
    let name: String
    let stages: Int
    let costPerLaunch: Int
    let firstFlight: String
    let id: String
}

// MARK: - Diameter

extension RocketModelElement {
    struct Diameter: Decodable, Equatable {
        let meters: Double?
        let feet: Double?
    }

// MARK: - FirstStage

    struct FirstStage: Decodable, Equatable {
        let engines: Int
        let fuelAmountTons: Double
        let burnTimeSec: Int?
    }

// MARK: - Mass

    struct Mass: Decodable, Equatable {
        let kg: Int
        let lb: Int
    }

// MARK: - PayloadWeight

    struct PayloadWeight: Decodable, Equatable {
        let kg: Int
        let lb: Int
    }

// MARK: - SecondStage

    struct SecondStage: Decodable, Equatable {
        let engines: Int
        let fuelAmountTons: Double
        let burnTimeSec: Int?
    }
}
