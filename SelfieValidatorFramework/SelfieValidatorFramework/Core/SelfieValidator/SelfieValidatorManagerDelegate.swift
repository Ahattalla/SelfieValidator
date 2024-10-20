import UIKit

protocol SelfieValidatorManagerDelegate: AnyObject {
    func selfieValidatorManager(_ manager: SelfieValidatorManager, didCapturePhoto photo: UIImage)
}
