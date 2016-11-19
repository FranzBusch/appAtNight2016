import Alamofire

protocol Cancellable {
    func cancel()
}

extension Request: Cancellable { }
