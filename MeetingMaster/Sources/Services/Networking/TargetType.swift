import Alamofire

typealias HTTPMethod = Alamofire.HTTPMethod

enum ParameterEncoding {
    case url
    case json

    func encode(_ request: URLRequest, with paramters: [String: Any]?) throws -> URLRequest {
        return try encoder.encode(request, with: paramters)
    }

    private var encoder: Alamofire.ParameterEncoding {
        switch self {
        case .url:
            return URLEncoding(destination: .queryString)
        case .json:
            return JSONEncoding.default
        }
    }
}

protocol TargetType: URLRequestConvertible {
    var baseURL: URL { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var encoding: ParameterEncoding { get }
    var parameters: [String: Any]? { get }
    var httpHeaderFields: [String: String]? { get }
}

extension TargetType {

    func asURLRequest() throws -> URLRequest {
        let url = baseURL.appendingPathComponent(path)
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.allHTTPHeaderFields = httpHeaderFields

        return try encoding.encode(request, with: parameters)
    }

}
