import UIKit
import Moya
import AVFoundation
import PromiseKit
import NotificationBannerSwift

class FaceDetectionViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    
    let faceDetectionService:FaceDetectionService! = DefaultFaceDetectionService()
    
    private var uiService: UIService!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var emotionLabel: UILabel!
        
    @IBAction func takePhotoTapped(_ sender: Any) {
        getImage(useCamera: true)
    }
    
    @IBAction func pickImageTapped(_ sender: Any) {
        getImage(useCamera: false)
    }
    
    private var imageId = 0
    private func setImage(_ image: UIImage) {
        emotionLabel.text = nil
        imageView.image = image
        imageId += 1
        analyze()
    }
    
    private func getImage(useCamera:Bool) {
        uiService.getImage(useCamera: useCamera).done { image in
            NSLog("got image")
            self.setImage(image)
        }.catch { _ in
            
        }
    }
    
    
    private func setAnalysisResults(image:UIImage?, text:String?) {
        if let image = image {
            imageView.image = image
        }
        emotionLabel.text = text
    }
    
    private func analyze() {
        guard let image = imageView.image else { return  }
        
        activityIndicator.startAnimating()
        faceDetectionService.analyze(image: image, id:imageId).done { result  in
            let (id, response) = result
            guard id == self.imageId else {
                return
            }
            
            self.setAnalysisResults(image: response.croppedImage, text: response.emotion)
        }.catch { error in
            var banner = NotificationBanner(title: "An error occured", subtitle: "Please try again", style: .danger)
            if let error = error as? FaceDetectionServiceError {
                if error == .didNotDetectFace {
                    banner = NotificationBanner(title: "No face detected", subtitle: "Please try again", style: .warning)
                }
            }
            banner.show()
        }.finally {
            self.activityIndicator.stopAnimating()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityIndicator.transform = CGAffineTransform(scaleX: 2.0, y: 2.0)
        
        uiService = DefaultUIService(viewController: self)
    }
    
}

