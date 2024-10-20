import UIKit
import AVFoundation

class CameraManager: NSObject {
    private var captureSession: AVCaptureSession?
    private var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    private var videoOutput: AVCaptureVideoDataOutput?
    private var stillImageOutput: AVCapturePhotoOutput?

    weak var cameraManagerHelper: CameraManagerHelper?
    weak var cameraManagerDelegate: CameraManagerDelegate?
    
    func start() throws {
        captureSession = AVCaptureSession()
        captureSession?.sessionPreset = .high
        
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
        
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession!)
        videoPreviewLayer?.videoGravity = .resizeAspectFill
        if let previewLayer = videoPreviewLayer, let view = cameraManagerHelper?.videoPreviewLayerContainer {
            videoPreviewLayer?.frame = view.layer.bounds
            view.layer.addSublayer(previewLayer)
        }
        
        videoOutput = AVCaptureVideoDataOutput()
        videoOutput?.setSampleBufferDelegate(self, queue: DispatchQueue(label: "videoQueue"))
        if let videoOutput = videoOutput, captureSession?.canAddOutput(videoOutput) == true {
            captureSession?.addOutput(videoOutput)
        }
        
        stillImageOutput = AVCapturePhotoOutput()
        if let stillImageOutput = stillImageOutput, captureSession?.canAddOutput(stillImageOutput) == true {
            captureSession?.addOutput(stillImageOutput)
        }
        
        DispatchQueue.global().async {
            self.captureSession?.startRunning()
        }
    }
    
    func takePicture() {
        guard let stillImageOutput = stillImageOutput else { return }
        
        let settings = AVCapturePhotoSettings()
        stillImageOutput.capturePhoto(with: settings, delegate: self)
    }

    func stop() {
        captureSession?.stopRunning()
    }
}

extension CameraManager: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        cameraManagerDelegate?.cameraManager(self, didOutput: sampleBuffer)
    }
}

extension CameraManager: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if let error = error {
            print("Error capturing photo: \(error)")
            return
        }
        
        guard let imageData = photo.fileDataRepresentation(),
              let image = UIImage(data: imageData) else { return }
        cameraManagerDelegate?.cameraManager(self, didOutput: image)
    }
}


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
