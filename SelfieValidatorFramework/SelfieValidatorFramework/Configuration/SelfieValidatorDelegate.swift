import UIKit

public protocol SelfieValidatorDelegate: AnyObject {
    /// Delegate method that is called when a selfie is captured.
    /// - Parameter image: The captured selfie image.
    func didCaptureSelfie(_ image: UIImage)
}
