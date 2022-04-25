//
//  VisionBlinkDetectorVC.swift
//
//
//  Created with love and passion by Bertan
//
// UIKit ViewController with camera feed that draws a bounding box around a face and detects blinks
// Only once face ca be used to detect blinks at a time!

import UIKit
import AVKit
import Vision

final class VisionBlinkDetectorVC: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {
    // Class delegate property, see VisionBlinkDetectorVCDelegate.swift for more
    weak var delegate: VisionBlinkDetectorVCDelegate?

    // Customizable face rect color!
    var faceRectColor: UIColor = .systemIndigo

    // Computed property that returns the current device orientation
    private var orientation: UIInterfaceOrientation {
        // Not using UIDevice for orientation as it can return incorrect values when the app is first launched
        return (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.interfaceOrientation ?? .portrait
    }

    private let captureSession = AVCaptureSession()
    private let videoDataOutput = AVCaptureVideoDataOutput()

    private lazy var previewLayer = AVCaptureVideoPreviewLayer(session: self.captureSession)
    private var drawingLayers: [CAShapeLayer] = []
    private var lastFaceRectangleOrigin: CGPoint?

    // Closed eyes threshold should be smaller when in portrait orientation as the user is generally looking more down!
    private var closedEyesThreshold: CGFloat {
        if orientation.isPortrait {
            return 0.1
        } else {
            return 0.2
        }
    }

    // Setup the capture session on view appear
    override func viewDidLoad() {
        super.viewDidLoad()
        captureSessionSetup()
        captureSession.startRunning()
    }

    // Update orientation and preview layer frame on layout change
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateConnectionOrientation()
        self.previewLayer.frame = self.view.frame
    }

    // Method to update the orientation of the video feed
    private func updateConnectionOrientation() {
        guard let connection = previewLayer.connection else { return }

        let previewLayerConnection: AVCaptureConnection = connection

        if previewLayerConnection.isVideoOrientationSupported {
            previewLayerConnection.videoOrientation = AVCaptureVideoOrientation(
                rawValue: orientation.rawValue) ?? .portrait
        }
        self.previewLayer.frame = self.view.frame
    }

    // Initial setup method for the preview layer
    private func previewLayerSetup() {
        self.previewLayer.videoGravity = .resizeAspectFill
        self.view.layer.addSublayer(self.previewLayer)
        self.previewLayer.frame = self.view.frame

        self.videoDataOutput.videoSettings = [(kCVPixelBufferPixelFormatTypeKey as NSString):
                                                NSNumber(value: kCVPixelFormatType_32BGRA)] as [String: Any]

        self.videoDataOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "camBufferQueue"))
        self.captureSession.addOutput(self.videoDataOutput)

        // Specify video format usage!
        let videoConnection = self.videoDataOutput.connection(with: .video)
        videoConnection?.videoOrientation = .portrait
    }

    // Method to check and request camera permission - returns true when granted
    private func checkCamPermission() async -> Bool {
        // Get the current permission status for video format
        let permission = AVCaptureDevice.authorizationStatus(for: .video)

        switch permission {
        case .authorized:
            return true
        case .notDetermined:
            // Show permission prompt to user if they are using the app for the first time
            // Wait for the user response with Swift Concurrency
            return await withCheckedContinuation { continuation in
                AVCaptureDevice.requestAccess(for: .video) { granted in
                    continuation.resume(returning: granted)
                }
            }
        default:
            return false
        }
    }

    // Initial setup for the capture session
    private func captureSessionSetup() {

        // Check camera permission first, and return error on delegate completion method if not granted
        Task(priority: .userInitiated) {
            if await !checkCamPermission() {
                delegate?.onCamInitComplete(VBDError.camPermissionDenied)
                return
            }

            // Try to define a capture device placed in front of the device for video
            // If none found, return error on delegate completion method
            guard let captureDevice = AVCaptureDevice.default(.builtInWideAngleCamera,
                                                              for: .video, position: .front) else {
                delegate?.onCamInitComplete(VBDError.noCaptureDevices)
                return
            }

            // Set up Center Stage on supported devices!
            if captureDevice.activeFormat.isCenterStageSupported {
                AVCaptureDevice.centerStageControlMode = .cooperative
                AVCaptureDevice.isCenterStageEnabled = true
            }

            // Check if the capture device has inputs, if not, return error on delegate completion method
            guard let deviceInput = try? AVCaptureDeviceInput(device: captureDevice) else {
                delegate?.onCamInitComplete(VBDError.noInputs)
                return
            }
            // Try to add input from capture device, if cannot, return error on delegate completion method
            if captureSession.canAddInput(deviceInput) {
                captureSession.addInput(deviceInput)
                previewLayerSetup()
            } else {
                delegate?.onCamInitComplete(VBDError.invalidInputs)
            }

            // If everything went well and we're still here, call the delegate completion method returning nil for error
            delegate?.onCamInitComplete(nil)
        }

    }
}

// Implementing Vision framework functionality
extension VisionBlinkDetectorVC {
    // Method to calculate the Euclidean distance of two points based on the Pythagorean theorem
    private func euclideanDistance(from pt1: CGPoint, to pt2: CGPoint) -> Double {
        let distanceX = pt2.x - pt1.x
        let distanceY = pt2.y - pt1.y

        let dxSquared = pow(distanceX, 2)
        let dySquared = pow(distanceY, 2)

        let euclideanDistance = sqrt(dxSquared + dySquared)

        return euclideanDistance
    }

    // Method to calculate the eye aspect ratio. It determines how wide the eye is open
    // As the value reaches to 0, it gets more probable that the eye is closed
    private func calculateEAR(eyePoints: [CGPoint], faceBoundingBox: CGRect) -> Double {
        // Adjust for different device orientations!
        let xDivisor = orientation.isPortrait ? faceBoundingBox.width : faceBoundingBox.height
        let yDivisor = orientation.isPortrait ? faceBoundingBox.height : faceBoundingBox.width

        let points = eyePoints.map { CGPoint(x: $0.x / xDivisor, y: $0.y / yDivisor) }

        let distance1 = euclideanDistance(from: points[1], to: points[5])
        let distance2 = euclideanDistance(from: points[2], to: points[4])
        let distance3 = euclideanDistance(from: points[0], to: points[3])

        let EAR = (distance1 + distance2) / (2.0 * distance3)
        return EAR
    }

    // Method that scales up the face bounding box rectangle to look better
    private func scaledUpRect(rect: CGRect, scale: Double) -> CGRect {
        let adjustedWidth = rect.width * scale / 2
        let adjustmentHeight = rect.height * scale / 2
        return rect.insetBy(dx: -adjustedWidth, dy: -adjustmentHeight)
    }

    // Method that draws a rectangle around a bounding box provided on the camera preview layer
    private func drawFaceRectangle(boundingBox: CGRect) {
        let scaledRect = scaledUpRect(rect: boundingBox, scale: 0)
        // Change the radius of the rectangle depending on its size to look nice
        let radiusSize = scaledRect.height / 15

        // Create the rectangle path!
        let drawingPath = UIBezierPath(roundedRect: scaledRect, byRoundingCorners: .allCorners,
                                       cornerRadii: CGSize(width: radiusSize, height: radiusSize)).cgPath

        // Create s shape using the path we created
        let drawingLayer = CAShapeLayer()
        drawingLayer.path = drawingPath

        // The line with of the rectangle changes depending on the size of the rectangle as well!
        drawingLayer.lineWidth = radiusSize / 5
        // Make the rectangle transparent with the strokes being the specified color by the user
        drawingLayer.fillColor = UIColor.clear.cgColor
        drawingLayer.strokeColor = faceRectColor.cgColor

        // Clear all previous rectangles and add the newly created one on the camera preview layer
        clearFaceRectangle()
        self.drawingLayers.append(drawingLayer)
        self.view.layer.addSublayer(drawingLayer)

        self.lastFaceRectangleOrigin = boundingBox.origin
    }

    // Method to remove all face rectangles on the camera preview layer
    private func clearFaceRectangle() {
        self.drawingLayers.forEach { drawing in drawing.removeFromSuperlayer() }
    }

    // Method to handle and process face data detected by the Vision framework
    private func handleFaceDetectionObservations(observations: [VNFaceObservation]) {
        // Check the face observation count first since it only works with one face
        // If no faces or multiple faces found, set the blink state accordingly and return
        // If only one face detected, continue!
        switch observations.count {
        case 0:
            clearFaceRectangle()
            delegate?.detectedState = .noFaces
            return
        case 1:
            break
        default:
            clearFaceRectangle()
            delegate?.detectedState = .multipleFaces
            return
        }

        // If we're here, there will be only one face observation for sure, and we'll work with that one.
        // Guard statement here just to be sure though
        guard let observation = observations.first else {
            print("BUG FOUND: Could not get the first face observation even though one was detected!")
            return
        }

        // Get the face bounding box rect to draw a rectangle around the face
        let drawingRect = self.previewLayer.layerRectConverted(fromMetadataOutputRect: observation.boundingBox)

        // The face bounding box position is extremely sensitive and changes quickly
        // Even though this is a good, it causes the rectangle to be shaky
        // So this code only updates the view if the position has displaced more than 20 points to prevent shakiness
        if let lastFaceRectangleOrigin = lastFaceRectangleOrigin {
            let displacement = euclideanDistance(from: lastFaceRectangleOrigin, to: drawingRect.origin)
            if displacement > 20 {
                drawFaceRectangle(boundingBox: drawingRect)
            }
        } else {
            // Also draw a rectangle if none were drawn before
            drawFaceRectangle(boundingBox: drawingRect)
        }

        // Check if both eyes are closed by comparing them to the threshold defined above
        if let landmarks = observation.landmarks {
            if let leftEye = landmarks.leftEye, let rightEye = landmarks.rightEye {
                let boundingBox = observation.boundingBox
                let leftEAR = calculateEAR(eyePoints: leftEye.normalizedPoints, faceBoundingBox: boundingBox)
                let rightEAR = calculateEAR(eyePoints: rightEye.normalizedPoints, faceBoundingBox: boundingBox)

                if leftEAR < closedEyesThreshold || rightEAR < closedEyesThreshold {
                    delegate?.detectedState = .eyesClosed

                } else {
                    delegate?.detectedState = .eyesOpen
                }
            }
        }
    }

    // Protocol method that gets called when the camera feed outputs new data
    func captureOutput(_ output: AVCaptureOutput,
                       didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {

        // Try to get image buffer from CMSampleBuffer
        // We will put the image buffer into vision to detect faces!
        guard let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            print("VisionBlinkDetectorVC: Cannot get image buffer!")
            return
        }

        // Create request to detect face landmarks from the image buffer using the Vision framework
        let landmarksRequest = VNDetectFaceLandmarksRequest(completionHandler: { (request: VNRequest, _) in
            DispatchQueue.main.async {
                if let observations = request.results as? [VNFaceObservation] {
                    // When landmarks are detected, process the results with the method above
                    self.handleFaceDetectionObservations(observations: observations)
                }
            }
        })
        let imageRequestHandler = VNImageRequestHandler(cvPixelBuffer: imageBuffer,
                                                        orientation: .leftMirrored, options: [:])

        // Try and run the face landmark request!
        do {
            try imageRequestHandler.perform([landmarksRequest])
        } catch {
            print(error.localizedDescription)
        }
    }
}
