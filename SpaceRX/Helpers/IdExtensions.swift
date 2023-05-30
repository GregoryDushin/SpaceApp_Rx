
import UIKit

// MARK: - Cell Identifire Helpers

protocol ReuseIdentifying {
    static var reuseIdentifier: String { get }
}

extension ReuseIdentifying {
    static var reuseIdentifier: String {
        String(describing: Self.self)
    }
}

extension UICollectionReusableView: ReuseIdentifying {}

extension UITableViewCell: ReuseIdentifying {}

extension UIImage {
  static func named(_ name: String) -> UIImage {
    if let image = UIImage(named: name) {
      return image
    } else {
      fatalError("Could not initialize \(UIImage.self) named \(name).")
    }
  }
}
