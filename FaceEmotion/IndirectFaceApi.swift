import Moya
import UIKit

enum IndirectFaceApi {
    case analyzeImage(image:UIImage)
}

extension IndirectFaceApi : TargetType {
    
    var baseURL: URL {
        return URL(string:"https://ofirfaceapi.azurewebsites.net")!
    }
    
    var path: String {
        return "face"
    }
    
    var method: Moya.Method {
        .post
    }

    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
        case .analyzeImage(let image):
            return .requestData(ImageUtil.imageToData(image: image))
        }

    }
    
    var headers: [String : String]? {
        return ["Content-Type":"application/octet-stream"]
    }

}
