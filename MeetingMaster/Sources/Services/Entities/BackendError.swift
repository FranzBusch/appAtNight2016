import Gloss

struct BackendError: Decodable {

    var errorCode: String
    var message: String
    var retriable: Bool

    init?(json: JSON) {
        guard let errorCode: String = "errorCode" <~~ json,
            let message: String = "message" <~~ json,
            let retriable: Bool = "retriable" <~~ json else {
                return nil
        }

        self.errorCode = errorCode
        self.message = message
        self.retriable = retriable
    }

}
