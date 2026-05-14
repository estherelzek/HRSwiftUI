//
//  FaceAuthentication.swift
//  HRSwiftUI
//
//  Created by Esther Elzek on 03/05/2026.
//

import SwiftUI
import AVFoundation

struct FaceAuthentication: View {
    @State private var isCameraAuthorized = false
    @State private var showCamera = false
    @State private var capturedImage: UIImage? = nil
    @State private var errorMessage = ""
    @State private var showError = false
    @Environment(\.dismiss) var dismiss
    var onSuccess: (() -> Void)? = nil
    
    var body: some View {
        ZStack {
            Color(.systemBackground).ignoresSafeArea()
            
            VStack(spacing: 24) {
            // MARK: - Header
            VStack(spacing: 8) {
                Image(systemName: "faceid")
                    .font(.system(size: 60))
                    .foregroundStyle(Color(red: 75/255, green: 100/255, blue: 74/255))
                
                Text("Set Your Face")
                    .font(.title2.bold())
                    .foregroundStyle(.primary)
                
                Text("Capture your face to set up Face ID protection")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
            .padding(.top, 40)
            
            Spacer()
            
            // MARK: - Camera Preview or Capture Button
            if let image = capturedImage {
                VStack(spacing: 16) {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 200, height: 240)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color(red: 75/255, green: 100/255, blue: 74/255), lineWidth: 2)
                        )
                    
                    Text("Face captured successfully!")
                        .font(.subheadline)
                        .foregroundStyle(.green)
                    
                    Button("Retake") {
                        capturedImage = nil
                        showCamera = true
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(Color(.systemGray5))
                    .foregroundStyle(.primary)
                    .cornerRadius(12)
                }
                .padding(.horizontal, 24)
            } else {
                VStack(spacing: 20) {
                    Image(systemName: "camera.fill")
                        .font(.system(size: 60))
                        .foregroundStyle(.secondary)
                    
                    Text("Ready to capture your face")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    
                    Button("Open Camera") {
                        requestCameraAccess()
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(Color(red: 75/255, green: 100/255, blue: 74/255))
                    .foregroundStyle(.white)
                    .cornerRadius(12)
                }
                .padding(.horizontal, 24)
                .padding(.vertical, 40)
                .background(Color(.systemGray6))
                .cornerRadius(16)
                .padding(.horizontal, 24)
            }
            
            Spacer()
            
            // MARK: - Action Buttons
            HStack(spacing: 12) {
                Button("Cancel") {
                    dismiss()
                }
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .background(Color(.systemGray5))
                .foregroundStyle(.primary)
                .cornerRadius(12)
                
                if capturedImage != nil {
                    Button("Confirm") {
                        onSuccess?()
                        dismiss()
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(Color(red: 75/255, green: 100/255, blue: 74/255))
                    .foregroundStyle(.white)
                    .cornerRadius(12)
                }
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 24)
        }
        }
        .sheet(isPresented: $showCamera) {
            CameraViewControllerRepresentable(image: $capturedImage, showCamera: $showCamera)
        }
        .alert("Camera Error", isPresented: $showError) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(errorMessage)
        }
    }
    
    // MARK: - Camera Permission
    func requestCameraAccess() {
        AVCaptureDevice.requestAccess(for: .video) { granted in
            DispatchQueue.main.async {
                if granted {
                    isCameraAuthorized = true
                    showCamera = true
                } else {
                    errorMessage = "Camera access is required to set up Face ID. Please enable it in Settings."
                    showError = true
                }
            }
        }
    }
}

// MARK: - Camera View Controller
struct CameraViewControllerRepresentable: UIViewControllerRepresentable {
    @Binding var image: UIImage?
    @Binding var showCamera: Bool
    @Environment(\.dismiss) var dismiss
    
    func makeUIViewController(context: Context) -> CameraViewController {
        let controller = CameraViewController()
        controller.onImageCapture = { capturedImage in
            image = capturedImage
            showCamera = false
            dismiss()
        }
        return controller
    }
    
    func updateUIViewController(_ uiViewController: CameraViewController, context: Context) {}
}

// MARK: - Camera Controller
class CameraViewController: UIViewController, AVCapturePhotoCaptureDelegate {
    var captureSession: AVCaptureSession?
    var previewLayer: AVCaptureVideoPreviewLayer?
    var photoOutput: AVCapturePhotoOutput?
    var onImageCapture: ((UIImage) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCamera()
        addCaptureButton()
    }
    
    func setupCamera() {
        let session = AVCaptureSession()
        session.sessionPreset = .photo
        
        guard let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front) else {
            print("Front camera not available")
            return
        }
        
        do {
            let input = try AVCaptureDeviceInput(device: device)
            session.addInput(input)
        } catch {
            print("Error setting camera input: \(error)")
            return
        }
        
        let photoOutput = AVCapturePhotoOutput()
        session.addOutput(photoOutput)
        self.photoOutput = photoOutput
        
        let previewLayer = AVCaptureVideoPreviewLayer(session: session)
        previewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer)
        self.previewLayer = previewLayer
        
        self.captureSession = session
        DispatchQueue.global(qos: .background).async {
            session.startRunning()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        previewLayer?.frame = view.bounds
    }
    
    func addCaptureButton() {
        let button = UIButton(type: .system)
        button.setTitle("Capture", for: .normal)
        button.backgroundColor = UIColor(red: 75/255, green: 100/255, blue: 74/255, alpha: 1)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.frame = CGRect(x: view.center.x - 50, y: view.frame.height - 120, width: 100, height: 50)
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(capturePhoto), for: .touchUpInside)
        view.addSubview(button)
    }
    
    @objc func capturePhoto() {
        let settings = AVCapturePhotoSettings()
        settings.flashMode = .off
        photoOutput?.capturePhoto(with: settings, delegate: self)
    }
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard let imageData = photo.fileDataRepresentation(),
              let image = UIImage(data: imageData) else {
            return
        }
        
        DispatchQueue.main.async {
            self.onImageCapture?(image)
            self.captureSession?.stopRunning()
        }
    }
}

#Preview {
    FaceAuthentication()
}
