import UIKit

public enum Configurations {
    public private(set) static var delegate: SelfieValidatorDelegate?
}

public extension Configurations {
    static func setup(delegate: SelfieValidatorDelegate) {
        Configurations.delegate = delegate
    }
}

public func getSelfieValidationScene() -> UIViewController {
    CameraViewController()
}
