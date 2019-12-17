struct FaceAttributes : Decodable {
    private let emotion: [String:Float]
    func feeling() -> String? {
        let maxFeeling = emotion.max { a, b in a.value < b.value } 
        
        guard let max = maxFeeling else {
            return nil
        }
        return max.value > 0.0 ? max.key : nil
    }
}

struct FaceRectangle : Decodable {
    let top:Int
    let left:Int
    let width:Int
    let height:Int
}
struct Face : Decodable {
    let faceId:String
    let faceRectangle: FaceRectangle
    let faceAttributes: FaceAttributes
}

