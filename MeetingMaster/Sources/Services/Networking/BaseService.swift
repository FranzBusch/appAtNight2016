import Gloss
import UIKit

enum ServiceError: Error {
    case backend(BackendError)
    case networking(NetworkingError)
    case underlying(Error)
}

protocol BaseService {

    associatedtype Target: TargetType

    static var provider: NetworkingProvider<Target> { get set }

    @discardableResult static func request<D: Decodable>(target: Target, completion: ((_ result: Result<D, ServiceError>) -> Void)?) -> Cancellable
    @discardableResult static func request<D: Decodable>(target: Target, completion: ((_ result: Result<[D], ServiceError>) -> Void)?) -> Cancellable
    @discardableResult static func request(target: Target, completion: ((_ result: Result<UIImage, ServiceError>) -> Void)?) -> Cancellable
    @discardableResult static func request(target: Target, completion: ((_ result: Result<Bool, ServiceError>) -> Void)?) -> Cancellable

}

extension BaseService {

    @discardableResult static func request<D: Decodable>(target: Target, completion: ((_ result: Result<D, ServiceError>) -> Void)?) -> Cancellable {
        return request(target: target, mappingClosure: { response in
            let object: D = try response.mapObject()
            completion?(.success(object))
        }, completion: completion)
    }

    @discardableResult static func request<D: Decodable>(target: Target, completion: ((_ result: Result<[D], ServiceError>) -> Void)?) -> Cancellable {
        return request(target: target, mappingClosure: { response in
            let array: [D] = try response.mapArray()
            completion?(.success(array))
        }, completion: completion)
    }

    @discardableResult static func request(target: Target, completion: ((_ result: Result<UIImage, ServiceError>) -> Void)?) -> Cancellable {
        return request(target: target, mappingClosure: { response in
            let image = try response.mapImage()
            completion?(.success(image))
        }, completion: completion)
    }

    @discardableResult static func request(target: Target, completion: ((_ result: Result<Bool, ServiceError>) -> Void)?) -> Cancellable {
        return request(target: target, mappingClosure: { response in
            completion?(.success(true))
        }, completion: completion)
    }

    @discardableResult static func request<M>(target: Target, mappingClosure: @escaping (_ response: Response) throws -> Void, completion: ((_ result: Result<M, ServiceError>) -> Void)?) -> Cancellable {
        return provider.request(target: target) { result in
            do {
                let response = try filterErrors(result: result)
                try mappingClosure(response)
            } catch let error as ServiceError {
                completion?(.failure(error))
            } catch let error as NetworkingError {
                completion?(.failure(.networking(error)))
            } catch {
                completion?(.failure(.underlying(error)))
            }
        }
    }

    static func filterErrors(result: Result<Response, NetworkingError>) throws -> Response {
        switch result {
        case .success(let response):
            do {
                let response = try response.filterSuccessfulStatusCodes()
                return response
            } catch {
                let backendError: BackendError = try response.mapObject()
                throw ServiceError.backend(backendError)
            }
        case .failure(let error):
            throw ServiceError.networking(error)
        }
    }

}
