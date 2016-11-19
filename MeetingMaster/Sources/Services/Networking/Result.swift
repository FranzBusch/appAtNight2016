import Foundation

enum Result<Value, Error: Swift.Error> {
    case success(Value)
    case failure(Error)

    var value: Value? {
        guard case let .success(value) = self else {
            return nil
        }

        return value
    }

    var error: Error? {
        guard case let .failure(error) = self else {
            return nil
        }

        return error
    }
}
