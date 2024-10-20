import UIKit
import AVFoundation

class CameraManager: NSObject {
    private var captureSession: AVCaptureSession?
    private var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    private var videoOutput: AVCaptureVideoDataOutput?
    private var stillImageOutput: AVCapturePhotoOutput?

    weak var cameraManagerHelper: CameraManagerHelper?
    weak var cameraManagerDelegate: CameraManagerDelegate?
    
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
    
    private func setupCaptureSession() {
        captureSession = AVCaptureSession()
        captureSession?.sessionPreset = .high
    }
    
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
    
    private func setupVideoPreviewLayer() {
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession!)
        videoPreviewLayer?.videoGravity = .resizeAspectFill
        if let previewLayer = videoPreviewLayer, let view = cameraManagerHelper?.videoPreviewLayerContainer {
            videoPreviewLayer?.frame = view.layer.bounds
            view.layer.addSublayer(previewLayer)
        }
    }
    
    private func setupVideoOutput() {
        videoOutput = AVCaptureVideoDataOutput()
        videoOutput?.setSampleBufferDelegate(self, queue: DispatchQueue(label: "videoQueue"))
        if let videoOutput = videoOutput, captureSession?.canAddOutput(videoOutput) == true {
            captureSession?.addOutput(videoOutput)
        }
    }
    
    private func setupStillImageOutput() {
        stillImageOutput = AVCapturePhotoOutput()
        if let stillImageOutput = stillImageOutput, captureSession?.canAddOutput(stillImageOutput) == true {
            captureSession?.addOutput(stillImageOutput)
        }
    }
    
    func takePicture() {
        guard let stillImageOutput = stillImageOutput else { return }
        
        let settings = AVCapturePhotoSettings()
        stillImageOutput.capturePhoto(with: settings, delegate: self)
    }

    func stopSession() {
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
            debugPrint("Error capturing photo: \(error)")
            return
        }
        
        guard let imageData = photo.fileDataRepresentation(),
              let image = UIImage(data: imageData) else { return }
        cameraManagerDelegate?.cameraManager(self, didOutput: image)
    }
}
