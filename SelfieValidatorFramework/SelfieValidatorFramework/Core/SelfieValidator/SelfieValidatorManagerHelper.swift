import UIKit

protocol SelfieValidatorManagerHelper: AnyObject {
    /// A computed property that provides access to the container view for the selfie validator.
    /// This view is used to display the selfie validation interface.
    var selfieValidatorViewContainer: UIView { get }
}
