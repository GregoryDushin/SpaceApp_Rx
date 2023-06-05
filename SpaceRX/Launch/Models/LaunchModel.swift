import Foundation

struct LaunchModelElement: Decodable, Equatable {
    let success: Bool?
    let name: String
    let dateUtc: Date
    let rocket: String
}
