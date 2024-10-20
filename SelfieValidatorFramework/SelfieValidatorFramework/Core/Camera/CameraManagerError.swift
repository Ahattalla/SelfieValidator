import Foundation

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
