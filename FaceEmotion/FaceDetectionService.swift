import UIKit
import PromiseKit

struct FaceDetectionServiceResponse {
    let croppedImage:UIImage
    let emotion:String
}

enum FaceDetectionServiceError : Error {
    case failedParsing
    case didNotDetectFace
    case badServerResponse
}

protocol FaceDetectionService {
    func analyze(image:UIImage, id:Int) -> Promise<(Int,FaceDetectionServiceResponse)>
}
