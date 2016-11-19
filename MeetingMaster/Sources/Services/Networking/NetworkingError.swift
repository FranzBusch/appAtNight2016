import Foundation

enum NetworkingError: Error {
    case statusCode(Response)
    case jsonMapping(Response)
    case imageMapping(Response)
    case underlying(Error)

    var isCancelled: Bool {
        guard case let .underlying(error) = self else {
            return false
        }

        return (error as NSError).code == NSURLErrorCancelled
    }

}
