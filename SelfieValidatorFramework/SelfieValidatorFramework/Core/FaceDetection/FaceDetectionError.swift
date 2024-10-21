import Foundation

/// An enumeration representing errors that can occur during face detection.
///
/// - failedToPerformFaceDetection: Indicates that face detection failed due to an underlying error.
///   - error: The underlying error that caused the face detection to fail.
enum FaceDetectionError: Error, LocalizedError {
    case failedToPerformFaceDetection(Error)
    
    var errorDescription: String? {
        switch self {
        case .failedToPerformFaceDetection(let error):
            return "Failed to perform face detection: \(error)"
        }
    }
}
