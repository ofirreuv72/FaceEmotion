import  Moya

enum FaceApi {
    case analyzeImage(image:UIImage)

}

extension FaceApi : TargetType {
        
    var baseURL: URL {
        return URL(string:"https://orfaceapi.cognitiveservices.azure.com")!
    }
    
    var path: String {
        return "face/v1.0/detect"
    }
    
    var method: Method {
        .post
    }
    
    var sampleData: Data {
        let data = """
                      [{"faceId":"281cdf28-41ba-4756-8d94-168557ef9663","faceRectangle":{"top":122,"left":59,"width":177,"height":177},"faceAttributes":{"emotion":{"anger":0.0,"contempt":0.0,"disgust":0.0,"fear":0.0,"happiness":1.0,"neutral":0.0,"sadness":0.0,"surprise":0.0}}}]
        """.data(using: .ascii)!
        return data
    }
    
    
    var parameters: [String: Any]? {
        return [
            "returnFaceId": "true",
            "returnFaceAttributes": "emotion",
            "returnFaceLandmarks": "false",
            "recognitionModel": "recognition_01",
            "returnRecognitionModel": "false",
            "detectionModel" : "detection_01",
        ]
    }
    
    var task: Task {
        switch self {
        case .analyzeImage(let image):
            let compressed = ImageUtil.compressImage(image: image)
            return .requestCompositeData(bodyData: ImageUtil.imageToData(image: compressed), urlParameters: parameters!)
        }
    }
    
    var headers: [String : String]? {
        [
            "Ocp-Apim-Subscription-Key": "386f1ee9f07a4278ba6440ad9db80580",
            "Content-Type":"application/octet-stream",
        ]
    }
    
    
}
