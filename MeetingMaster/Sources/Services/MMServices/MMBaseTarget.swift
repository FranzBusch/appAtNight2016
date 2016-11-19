import Foundation

enum MMBaseTarget: TargetType {
    case fetchMeeting
    case sensorData(Int)
    case uploadWav


    var baseURL: URL {
        return URL(string: "http://hackathonnoderedapp.eu-gb.mybluemix.net")!  // swiftlint:disable:this force_unwrapping
    }

    var path: String {
        switch self {
        case .fetchMeeting:
            return "meetings"
        case let .sensorData(id):
            return "meetings/\(id)/sensordata"
        case .uploadWav:
            return "uploadWav"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .fetchMeeting, .sensorData:
            return .get
        case .uploadWav:
            return .post
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
