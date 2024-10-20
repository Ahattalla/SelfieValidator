import UIKit

public protocol SelfieValidatorDelegate: AnyObject {
    func didCaptureSelfie(_ image: UIImage)
}
