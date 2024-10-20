import Vision
import UIKit

class FaceDetectionManager: NSObject {
    private var faceLayers = [CAShapeLayer]()
    
    // To keep track of detected face count
    private(set) var detectedFaceCount = 0
    
    weak var faceDetectionManagerHelper: FaceDetectionManagerHelper?
    func detectFaces(in sampleBuffer: CMSampleBuffer) throws {
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
        
        let request = VNDetectFaceRectanglesRequest { [weak self] (request, error) in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                self.clearFaceLayers()
            }
            
            if let results = request.results as? [VNFaceObservation] {
                DispatchQueue.main.async {
                    for face in results {
                        let boundingBox = self.transformBoundingBox(face.boundingBox)
                        self.addFaceBoundingBox(boundingBox)
                    }
                    
                    // Update detected face count
                    self.detectedFaceCount = results.count
                }
            }
        }
        
        let requestHandler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, orientation: .leftMirrored, options: [:])
        DispatchQueue.global(qos: .userInitiated).async {
            try? requestHandler.perform([request])
        }
    }
    
    private func transformBoundingBox(_ boundingBox: CGRect) -> CGRect {
        let size = faceDetectionManagerHelper?.faceDetectionViewContainer.frame.size ?? .zero
        let origin = CGPoint(x: boundingBox.origin.x * size.width, y: (1 - boundingBox.origin.y - boundingBox.height) * size.height)
        let scaledSize = CGSize(width: boundingBox.width * size.width, height: boundingBox.height * size.height)
        return CGRect(origin: origin, size: scaledSize)
    }
    
    private func addFaceBoundingBox(_ boundingBox: CGRect) {
        guard let view = faceDetectionManagerHelper?.faceDetectionViewContainer
                else { return }
        let faceLayer = CAShapeLayer()
        faceLayer.frame = boundingBox
        faceLayer.borderColor = UIColor.green.cgColor
        faceLayer.borderWidth = 2.0
        faceLayers.append(faceLayer)
        view.layer.addSublayer(faceLayer)
    }
    
    private func clearFaceLayers() {
        for layer in faceLayers {
            layer.removeFromSuperlayer()
        }
        faceLayers.removeAll()
    }
}

enum FaceDetectionError: Error, LocalizedError {
    case failedToPerformFaceDetection(Error)
    
    var errorDescription: String? {
        switch self {
        case .failedToPerformFaceDetection(let error):
            return "Failed to perform face detection: \(error)"
        }
    }
}
