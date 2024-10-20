import Foundation

/// An enumeration representing errors that can occur in the `CameraManager`.
///
/// - frontCameraNotAvailable: Indicates that the front camera is not available on the device.
/// - errorAddingCameraInput: Indicates that there was an error adding the camera input. The associated value provides more details about the error.
enum CameraManagerError: Error, LocalizedError {
    case frontCameraNotAvailable
    case errorAddingCameraInput(Error)
    
    var errorDescription: String? {
        switch self {
        case .frontCameraNotAvailable:
            return "Front camera is not available"
        case .errorAddingCameraInput(let error):
            return "Error adding camera input: \(error)"
        }
    }
}
