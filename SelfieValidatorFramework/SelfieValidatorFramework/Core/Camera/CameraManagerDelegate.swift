import UIKit
import AVFoundation

protocol CameraManagerDelegate: AnyObject {
    /// Called when the camera manager outputs a new pixel buffer.
    /// - Parameters:
    ///   - manager: The `CameraManager` instance that is providing the pixel buffer.
    ///   - pixelBuffer: The `CMSampleBuffer` containing the pixel data.
    func cameraManager(_ manager: CameraManager, didOutput pixelBuffer: CMSampleBuffer)

    /// Called when the camera manager outputs a new image.
    /// - Parameters:
    ///   - manager: The `CameraManager` instance that generated the image.
    ///   - image: The `UIImage` object that was captured by the camera.
    func cameraManager(_ manager: CameraManager, didOutput image: UIImage)
}
