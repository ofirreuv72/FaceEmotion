import UIKit

struct ImageUtil {
    static func cropImage(imageToCrop:UIImage, toRect rect:CGRect) -> UIImage {
        let imageRef:CGImage = imageToCrop.cgImage!.cropping(to: rect)!
        let cropped:UIImage = UIImage(cgImage:imageRef)
        return cropped
    }
    

    static func removeRotationForImage(image: UIImage) -> UIImage {
        if image.imageOrientation == UIImage.Orientation.up {
            return compressImage(image: image)
        }

        UIGraphicsBeginImageContextWithOptions(image.size, false, image.scale)
        image.draw(in: CGRect(origin: CGPoint(x: 0, y: 0), size: image.size))
        let normalizedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return normalizedImage
    }
    
    static func imageToData(image: UIImage) -> Data {
        let jpgData = image.jpegData(compressionQuality: 0.1)
        return jpgData!
    }

    static func compressImage(image: UIImage) -> UIImage {
        return UIImage(data: imageToData(image: image))!
    }

}
