import Foundation

enum MMBaseTarget: TargetType {
    case fetchMeeting
    case sensorData(Int)


    var baseURL: URL {
        return URL(string: "http://hackathonnoderedapp.eu-gb.mybluemix.net")!  // swiftlint:disable:this force_unwrapping
    }

    var path: String {
        switch self {
        case .fetchMeeting:
            return "meetings"
        case let .sensorData(id):
            return "meetings/\(id)/sensordata"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .fetchMeeting, .sensorData:
            return .get
        }
    }

    var encoding: ParameterEncoding {
        return .json
    }

    var parameters: [String : Any]? {
        return nil
    }

    var httpHeaderFields: [String: String]? {
        return nil
    }
}
