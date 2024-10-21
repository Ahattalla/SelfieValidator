import UIKit
import AVFoundation

class SelfieValidatorManager {
    
    // MARK: - Properties
    private let cameraManager: CameraManager = .init()
    private let faceDetectionManager: FaceDetectionManager = .init()
    
    private var currentCapturedImage: UIImage?

    // MARK: - Helper
    weak var selfieValidatorManagerHelper: SelfieValidatorManagerHelper?
    weak var selfieValidatorManagerDelegate: SelfieValidatorManagerDelegate?
    
    // MARK: - Initialization
    init() {
        cameraManager.cameraManagerHelper = self
        cameraManager.cameraManagerDelegate = self
        
        faceDetectionManager.faceDetectionManagerHelper = self
    }
    
    // MARK: - Methods

    /// Starts the selfie validation process by initializing necessary components.
    /// 
    /// This method ensures that the `selfieValidatorManagerHelper` is not nil before
    /// attempting to start the camera session. If `selfieValidatorManagerHelper` is nil,
    /// an assertion failure is triggered.
    /// 
    /// - Throws: An error if the camera session fails to start.
    func start() throws {
        guard selfieValidatorManagerHelper != nil else { return assertionFailure("selfieValidatorManagerHelper is nil") }
        try cameraManager.startSession()
    }
    
    /// Captures a photo using the camera manager after validating the number of detected faces.
    /// 
    /// - Throws: 
    ///   - `SelfieValidatorError.tooManyFaces` if more than one face is detected.
    ///   - `SelfieValidatorError.noFaces` if no faces are detected.
    func capturePhoto() throws {
        let facesCount = faceDetectionManager.detectedFaceCount
        if facesCount > 1 { throw SelfieValidatorError.tooManyFaces }
        if facesCount == 0 { throw SelfieValidatorError.noFaces }
        cameraManager.takePicture()
    }

    /// Approves the captured photo by stopping the camera session and notifying the delegate with the captured image.
    /// 
    /// This method stops the camera session using `cameraManager.stopSession()`. If there is a currently captured image,
    /// it calls the delegate method `didCaptureSelfie` with the captured image.
    func approvePhoto() {
        cameraManager.stopSession()
        
        guard let currentCapturedImage else { return }
        Configurations.delegate?.didCaptureSelfie(currentCapturedImage)
    }
}

// MARK: - CameraManagerDelegate
extension SelfieValidatorManager: CameraManagerDelegate {
    func cameraManager(_ manager: CameraManager, didOutput image: UIImage) {
        currentCapturedImage = image
        selfieValidatorManagerDelegate?.selfieValidatorManager(self, didCapturePhoto: image)
    }
    
    func cameraManager(_ manager: CameraManager, didOutput sampleBuffer: CMSampleBuffer) {
        try? faceDetectionManager.detectFaces(in: sampleBuffer)
    }
}

// MARK: - FaceDetectionManagerDelegate
extension SelfieValidatorManager: FaceDetectionManagerHelper {
    var faceDetectionViewContainer: UIView {
        self.selfieValidatorManagerHelper?.selfieValidatorViewContainer ?? .init()
    }
}

// MARK: - CameraManagerHelper
extension SelfieValidatorManager: CameraManagerHelper {
    var videoPreviewLayerContainer: UIView {
        self.selfieValidatorManagerHelper?.selfieValidatorViewContainer ?? .init()
    }
}
