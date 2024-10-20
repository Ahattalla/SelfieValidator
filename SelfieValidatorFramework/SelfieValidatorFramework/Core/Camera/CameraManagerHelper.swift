import UIKit

protocol CameraManagerHelper: AnyObject {
    /// A container view for displaying the video preview layer.
    /// This view is used to present the camera's video feed to the user.
    var videoPreviewLayerContainer: UIView { get }
}
