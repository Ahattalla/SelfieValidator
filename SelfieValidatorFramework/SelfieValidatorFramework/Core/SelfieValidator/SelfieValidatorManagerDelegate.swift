import UIKit

protocol SelfieValidatorManagerDelegate: AnyObject {
    /// Called when the `SelfieValidatorManager` captures a photo.
    /// - Parameters:
    ///   - manager: The `SelfieValidatorManager` instance that captured the photo.
    ///   - photo: The captured `UIImage`.
    func selfieValidatorManager(_ manager: SelfieValidatorManager, didCapturePhoto photo: UIImage)
}
