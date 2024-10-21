import UIKit

protocol FaceDetectionManagerHelper: AnyObject {
    /// A container view for displaying face detection results.
    /// This property provides a UIView that can be used to present the output of the face detection process.
    var faceDetectionViewContainer: UIView { get }
}
