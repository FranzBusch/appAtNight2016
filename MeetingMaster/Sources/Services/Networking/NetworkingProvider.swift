import Alamofire

class NetworkingProvider<Target: TargetType> {

    let sessionManager: SessionManager

    init(sessionManager: SessionManager = Alamofire.SessionManager.default) {
        self.sessionManager = sessionManager
    }

    @discardableResult func request(target: Target, completion: @escaping (Result<Response, NetworkingError>) -> ()) -> Cancellable {
        return sessionManager.request(target).response { (response) in
            let result = self.convertResponseToResult(response: response.response, data: response.data, error: response.error)
            completion(result)
        }
    }

}


extension NetworkingProvider {

    func convertResponseToResult(response: HTTPURLResponse?, data: Data?, error: Error?) -> Result<Response, NetworkingError> {
        switch (response, data, error) {
        case let (.some(response), data, .none):
            let response = Response(statusCode: response.statusCode, data: data ?? Data(), response: response)
            return .success(response)
        case let (_, _, .some(error)):
            let error = NetworkingError.underlying(error)
            return .failure(error)
        default:
            let error = NetworkingError.underlying(NSError(domain: NSURLErrorDomain, code: NSURLErrorUnknown, userInfo: nil))
            return .failure(error)
        }
    }
}
