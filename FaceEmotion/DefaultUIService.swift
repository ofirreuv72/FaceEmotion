import PromiseKit
import AVFoundation

class DefaultUIService : NSObject, UIService, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    private let pickerController = UIImagePickerController()
    private weak var viewController:UIViewController?
    init(viewController:UIViewController) {
        self.viewController = viewController
        super.init()
        configureImagePicker()
    }
    var resolver: Resolver<UIImage>!
    func getImage(useCamera:Bool) -> Promise<UIImage> {
        let (promise, resolver) = Promise<UIImage>.pending()
        self.resolver = resolver
        if useCamera {
            openCamera()
        } else {
            openPhotos()
        }
        return promise
    }
    
    private func configureImagePicker() {
        pickerController.mediaTypes = ["public.image"]
        
        pickerController.delegate = self
    }
    
    private func openPhotos() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            pickerController.sourceType = .photoLibrary
            
            viewController?.present(pickerController, animated: true, completion: nil)
        }
    }
    
    private func cameraAccess() -> Guarantee<Bool> {
        return Guarantee<Bool> { seal in
            AVCaptureDevice.requestAccess(for: .video) { success in
                seal(success)
            }
        }
    }
    
    private func openCamera() {
        func configureAndOpen() {
            if UIImagePickerController.isSourceTypeAvailable(.camera){
                pickerController.sourceType = .camera
                pickerController.cameraCaptureMode = .photo
                pickerController.cameraDevice = .front
                viewController?.present(self.pickerController, animated: true, completion: nil)
            }
        }
        // handler in .requestAccess is needed to process user's answer to our request
        cameraAccess().done { success in
            if success {
                configureAndOpen()
            } else {
                let alert = UIAlertController(title: "Camera", message: "Camera access is  necessary to use this feature", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Go To Settings", style: .default, handler: { action in
                    UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
                }))
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel) {_ in })
                
                self.viewController?.present(alert, animated: true)
            }
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            resolver.fulfill(ImageUtil.removeRotationForImage(image: image))
        } else {
            resolver.reject(UIServiceError.noImage)
        }
        
        viewController?.dismiss(animated: true, completion: nil)
    }
    
}
