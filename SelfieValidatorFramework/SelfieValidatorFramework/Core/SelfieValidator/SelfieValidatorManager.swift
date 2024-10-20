import UIKit
import AVFoundation

class SelfieValidatorManager {
    
    private let cameraManager: CameraManager = .init()
    private let faceDetectionManager: FaceDetectionManager = .init()
    
    weak var selfieValidatorManagerHelper: SelfieValidatorManagerHelper?
    weak var selfieValidatorManagerDelegate: SelfieValidatorManagerDelegate?
    
    private var currentCapturedImage: UIImage?
    
    init() {
        cameraManager.cameraManagerHelper = self
        cameraManager.cameraManagerDelegate = self
        
        faceDetectionManager.faceDetectionManagerHelper = self
    }
    
    func start() throws {
        guard selfieValidatorManagerHelper != nil else { return assertionFailure("selfieValidatorManagerHelper is nil") }
        try cameraManager.startSession()
    }
    
    func capturePhoto() throws {
        let facesCount = faceDetectionManager.detectedFaceCount
        if facesCount > 1 { throw SelfieValidatorError.tooManyFaces }
        if facesCount == 0 { throw SelfieValidatorError.noFaces }
        cameraManager.takePicture()
    }

    func approvePhoto() {
        cameraManager.stopSession()
        
        guard let currentCapturedImage else { return }
        Configurations.delegate?.didCaptureSelfie(currentCapturedImage)
    }
}

extension SelfieValidatorManager: CameraManagerDelegate {
    func cameraManager(_ manager: CameraManager, didOutput image: UIImage) {
        currentCapturedImage = image
        selfieValidatorManagerDelegate?.selfieValidatorManager(self, didCapturePhoto: image)
    }
    
    func cameraManager(_ manager: CameraManager, didOutput sampleBuffer: CMSampleBuffer) {
        try? faceDetectionManager.detectFaces(in: sampleBuffer)
    }
}

extension SelfieValidatorManager: FaceDetectionManagerHelper {
    var faceDetectionViewContainer: UIView {
        self.selfieValidatorManagerHelper?.selfieValidatorViewContainer ?? .init()
    }
}

extension SelfieValidatorManager: CameraManagerHelper {
    var videoPreviewLayerContainer: UIView {
        self.selfieValidatorManagerHelper?.selfieValidatorViewContainer ?? .init()
    }
}

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
