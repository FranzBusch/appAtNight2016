import Gloss
import UIKit

struct Response {

    let statusCode: Int
    let data: Data
    let response: URLResponse?

    init(statusCode: Int, data: Data, response: URLResponse? = nil) {
        self.statusCode = statusCode
        self.data = data
        self.response = response
    }

}

// MARK: StatusCodes
extension Response {

    func filterStatusCodes(range: ClosedRange<Int>) throws -> Response {
        guard range.contains(statusCode) else {
            throw NetworkingError.statusCode(self)
        }

        return self
    }

    func filterSuccessfulStatusCodes() throws -> Response {
        return try filterStatusCodes(range: 200...209)
    }

}

// MARK: Mapping
extension Response {

    func mapJSON() throws -> Any {
        do {
            return try JSONSerialization.jsonObject(with: data, options: .allowFragments)
        } catch {
            throw NetworkingError.underlying(error)
        }
    }

    func mapObject<D: Decodable>() throws -> D {
        guard let json = try mapJSON() as? JSON,
            let object = D(json: json) else {
            throw NetworkingError.jsonMapping(self)
        }

        return object
    }

    func mapArray<D: Decodable>() throws -> [D] {
        guard let json = try mapJSON() as? [JSON],
            let objects = [D].from(jsonArray: json) else {
            throw NetworkingError.jsonMapping(self)
        }

        return objects
    }

    func mapImage() throws -> UIImage {
        guard let image = UIImage(data: data) else {
            throw NetworkingError.imageMapping(self)
        }

        return image
    }

}
