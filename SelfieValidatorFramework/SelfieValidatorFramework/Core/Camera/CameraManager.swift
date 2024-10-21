import UIKit
import AVFoundation

class CameraManager: NSObject {
    // MARK: - Properties
    private var captureSession: AVCaptureSession?
    private var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    private var videoOutput: AVCaptureVideoDataOutput?
    private var stillImageOutput: AVCapturePhotoOutput?

    // MARK: - Helper
    weak var cameraManagerHelper: CameraManagerHelper?
    weak var cameraManagerDelegate: CameraManagerDelegate?
    
    // MARK: - Methods
    
    /// Starts the camera session by setting up the capture session, device input, video preview layer,
    /// video output, and still image output. The session is started asynchronously on a global dispatch queue.
    /// 
    /// - Throws: An error if setting up the device input fails.
    func startSession() throws {
        setupCaptureSession()
        try setupDeviceInput()
        setupVideoPreviewLayer()
        setupVideoOutput()
        setupStillImageOutput()
        
        DispatchQueue.global().async {
            self.captureSession?.startRunning()
        }
    }
    
    /// Sets up the capture session for the camera with a high-quality preset.
    /// Initializes the `AVCaptureSession` and configures it to use a high resolution preset.
    private func setupCaptureSession() {
        captureSession = AVCaptureSession()
        captureSession?.sessionPreset = .high
    }
    
    /// Sets up the device input for the camera session using the front camera.
    /// 
    /// This method attempts to find the front camera and add it as an input to the capture session.
    /// If the front camera is not available or there is an error adding the camera input, it throws an appropriate error.
    /// 
    /// - Throws: 
    ///   - `CameraManagerError.frontCameraNotAvailable` if the front camera is not available.
    ///   - `CameraManagerError.errorAddingCameraInput` if there is an error adding the camera input.
    private func setupDeviceInput() throws {
        guard let frontCamera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front) else {
            throw CameraManagerError.frontCameraNotAvailable
        }
        
        do {
            let input = try AVCaptureDeviceInput(device: frontCamera)
            if captureSession?.canAddInput(input) == true {
                captureSession?.addInput(input)
            }
        } catch {
            throw CameraManagerError.errorAddingCameraInput(error)
        }
    }
    
    /// Sets up the video preview layer for the camera session.
    /// 
    /// This method initializes the `AVCaptureVideoPreviewLayer` with the current capture session,
    /// sets its video gravity to resize aspect fill, and adds it as a sublayer to the container view's layer.
    /// 
    /// - Note: The `captureSession` must be non-nil for this method to function correctly.
    /// - Warning: Ensure that `cameraManagerHelper?.videoPreviewLayerContainer` is properly initialized before calling this method.
    private func setupVideoPreviewLayer() {
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession!)
        videoPreviewLayer?.videoGravity = .resizeAspectFill
        if let previewLayer = videoPreviewLayer, let view = cameraManagerHelper?.videoPreviewLayerContainer {
            videoPreviewLayer?.frame = view.layer.bounds
            view.layer.addSublayer(previewLayer)
        }
    }
    
    /// Sets up the video output for the capture session.
    /// 
    /// This method initializes the `AVCaptureVideoDataOutput` and sets its sample buffer delegate to self,
    /// using a dispatch queue labeled "videoQueue". If the capture session can add the video output, it is added to the session.
    private func setupVideoOutput() {
        videoOutput = AVCaptureVideoDataOutput()
        videoOutput?.setSampleBufferDelegate(self, queue: DispatchQueue(label: "videoQueue"))
        if let videoOutput = videoOutput, captureSession?.canAddOutput(videoOutput) == true {
            captureSession?.addOutput(videoOutput)
        }
    }
    
    /// Sets up the still image output for the camera session.
    /// 
    /// This method initializes the `AVCapturePhotoOutput` and adds it to the capture session
    /// if it can be added successfully. This allows the capture session to handle still image
    /// capture.
    ///
    /// - Note: Ensure that the capture session is properly configured before calling this method.
    private func setupStillImageOutput() {
        stillImageOutput = AVCapturePhotoOutput()
        if let stillImageOutput = stillImageOutput, captureSession?.canAddOutput(stillImageOutput) == true {
            captureSession?.addOutput(stillImageOutput)
        }
    }
    
    /// Captures a photo using the camera's still image output.
    /// 
    /// This function checks if the `stillImageOutput` is available and then
    /// captures a photo with the default settings. The captured photo is
    /// handled by the delegate methods of `AVCapturePhotoCaptureDelegate`.
    ///
    /// - Note: Ensure that `stillImageOutput` is properly configured before
    ///   calling this function.
    func takePicture() {
        guard let stillImageOutput = stillImageOutput else { return }
        
        let settings = AVCapturePhotoSettings()
        stillImageOutput.capturePhoto(with: settings, delegate: self)
    }

    /// Stops the current capture session if it is running.
    /// 
    /// This method stops the `captureSession` if it is currently running. 
    /// It is useful for releasing resources or pausing the camera functionality.
    func stopSession() {
        captureSession?.stopRunning()
    }
}

// MARK: - AVCaptureVideoDataOutputSampleBufferDelegate
extension CameraManager: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        cameraManagerDelegate?.cameraManager(self, didOutput: sampleBuffer)
    }
}

// MARK: - AVCapturePhotoCaptureDelegate
extension CameraManager: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if let error = error {
            debugPrint("Error capturing photo: \(error)")
            return
        }
        
        guard let imageData = photo.fileDataRepresentation(),
              let image = UIImage(data: imageData) else { return }
        cameraManagerDelegate?.cameraManager(self, didOutput: image)
    }
}
