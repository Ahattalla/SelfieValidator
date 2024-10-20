import UIKit

protocol CameraManagerDelegate: AnyObject {
    func cameraManager(_ manager: CameraManager, didOutput pixelBuffer: CMSampleBuffer)
    func cameraManager(_ manager: CameraManager, didOutput image: UIImage)
}
