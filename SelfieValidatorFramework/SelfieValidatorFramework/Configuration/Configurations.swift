import UIKit

/// An enumeration that holds configuration settings for the SelfieValidator framework.
public enum Configurations {
    /// A delegate that conforms to the `SelfieValidatorDelegate` protocol.
    /// This delegate is used to handle events and actions related to the SelfieValidator.
    /// The delegate can be set privately within the framework but can be accessed publicly.
    public private(set) static var delegate: SelfieValidatorDelegate?
}

/// Sets up the `Configurations` with the provided delegate.
///
/// - Parameter delegate: An instance conforming to `SelfieValidatorDelegate` that will handle validation events.
public extension Configurations {
    static func setup(delegate: SelfieValidatorDelegate) {
        Configurations.delegate = delegate
    }
}

/// Returns an instance of `CameraViewController` to be used for selfie validation.
///
/// - Returns: A `UIViewController` instance representing the selfie validation scene.
public func getSelfieValidationScene() -> UIViewController {
    CameraViewController()
}
