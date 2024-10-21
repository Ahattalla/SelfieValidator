import Foundation

/// An enumeration representing errors that can occur during selfie validation.
///
/// - tooManyFaces: Indicates that more than one face was detected in the selfie.
/// - noFaces: Indicates that no faces were detected in the selfie.
enum SelfieValidatorError: Error, LocalizedError {
    case tooManyFaces
    case noFaces
    
    var errorDescription: String? {
        switch self {
        case .tooManyFaces:
            return "Too many faces found, only one is allowed"
        case .noFaces:
            return "No faces found, please try again"
        }
    }
}

