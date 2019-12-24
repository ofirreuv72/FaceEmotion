import Moya
import PromiseKit

class DefaultFaceDetectionService : FaceDetectionService {
    
    func analyze(image: UIImage, id:Int) -> Promise<(Int,FaceDetectionServiceResponse)> {
        let provider = MoyaProvider<FaceApi>()
        return Promise<(Int,FaceDetectionServiceResponse)> { seal in
            let rotated = ImageUtil.removeRotationForImage(image: image)
            provider.request(.analyzeImage(image: rotated)) { result in
                switch result {
                case let .success(moyaResponse):
                    guard let faceApiResponse = try? JSONDecoder().decode([Face].self, from:moyaResponse.data)  else {
                        seal.reject(FaceDetectionServiceError.failedParsing)
                        return
                    }
                    
                    guard let face = faceApiResponse.first else {
                        seal.reject(FaceDetectionServiceError.didNotDetectFace) 
                        return
                    }
                    
                    let rect = face.faceRectangle
                    let imageRect = CGRect(x: rect.left, y: rect.top, width: rect.width, height: rect.height)
                    let newImg = ImageUtil.cropImage(imageToCrop: rotated, toRect: imageRect)
                    let response = FaceDetectionServiceResponse(croppedImage: newImg, emotion: face.faceAttributes.feeling() ?? "No emotion detected")
                    seal.fulfill((id,response))
                    
                case let .failure(error):
                    seal.reject(error)
                }
            }
        }
    }
}
