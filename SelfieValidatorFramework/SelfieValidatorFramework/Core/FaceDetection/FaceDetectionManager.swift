import Vision
import UIKit

class FaceDetectionManager: NSObject {

    // MARK: - Properties
    // To keep track of face layers
    private var faceLayers = [CAShapeLayer]()

    // To keep track of detected face count
    private(set) var detectedFaceCount = 0

    // MARK: - Helper
    weak var faceDetectionManagerHelper: FaceDetectionManagerHelper?
    
    // MARK: - Methods

    /// Detects faces in the provided sample buffer using Vision framework.
    ///
    /// - Parameter sampleBuffer: The sample buffer containing the image data.
    /// - Throws: An error if face detection fails.
    /// - Note: This method performs face detection asynchronously and updates the UI on the main thread.
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
    
    /// Transforms a bounding box from a normalized coordinate system to the coordinate system of the face detection view container.
    ///
    /// - Parameter boundingBox: The bounding box in normalized coordinates (values between 0 and 1).
    /// - Returns: The bounding box transformed to the coordinate system of the face detection view container.
    private func transformBoundingBox(_ boundingBox: CGRect) -> CGRect {
        let size = faceDetectionManagerHelper?.faceDetectionViewContainer.frame.size ?? .zero
        let origin = CGPoint(x: boundingBox.origin.x * size.width, y: (1 - boundingBox.origin.y - boundingBox.height) * size.height)
        let scaledSize = CGSize(width: boundingBox.width * size.width, height: boundingBox.height * size.height)
        return CGRect(origin: origin, size: scaledSize)
    }
    
    /// Adds a bounding box around the detected face on the view container.
    ///
    /// - Parameter boundingBox: The CGRect representing the bounding box of the detected face.
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
    
    /// Removes all face layers from their superlayer and clears the `faceLayers` array.
    private func clearFaceLayers() {
        for layer in faceLayers {
            layer.removeFromSuperlayer()
        }
        faceLayers.removeAll()
    }
}
