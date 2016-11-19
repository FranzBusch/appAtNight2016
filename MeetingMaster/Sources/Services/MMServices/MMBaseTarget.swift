import Foundation

protocol MMBaseTarget { }

extension MMBaseTarget {

    var baseURL: URL {
        return URL(string: "")!  // swiftlint:disable:this force_unwrapping
    }

    var httpHeaderFields: [String: String]? {
        return nil
    }
}
