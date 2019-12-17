import UIKit
import PromiseKit

enum UIServiceError : Error {
    case noImage
}
 
protocol UIService {
    func getImage(useCamera:Bool) -> Promise<UIImage>
}
