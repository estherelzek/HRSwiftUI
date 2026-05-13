//
//  ScanAndInfoView.swift
//  HRSwiftUI
//
//  Created by Esther Elzek on 30/04/2026.
//

import SwiftUI
import AVFoundation

struct ScanAndInfoView: View {
    @Binding var isLoggedIn: Bool
    @State private var encryptedCode = ""
    @State private var isScannerPresented = false
    @State private var cameraErrorMessage: String?
    @State private var showLogin = false

    var body: some View {
        VStack(spacing: 16) {
            Button {
                isScannerPresented = true
            } label: {
                Image("scan")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
            }
            .buttonStyle(.plain)

            Text("OR")
                .font(.largeTitle)
                .foregroundStyle(.border)
                .bold()

            TextField("Enter company encrypted code", text: $encryptedCode)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled(true)
                .padding(.horizontal, 12)
                .frame(height: 48)
                .background(Color(.systemBackground))
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.border, lineWidth: 1.5)
                )
                .cornerRadius(10)

            Button("Done") {
                showLogin = true
            }
            .frame(maxWidth: .infinity)
            .frame(height: 48)
            .background(Color.border)
            .foregroundStyle(.white)
            .cornerRadius(10)
        }
        .padding()
        .sheet(isPresented: $showLogin) {
            LoginView(isLoggedIn: $isLoggedIn)
        }
        .sheet(isPresented: $isScannerPresented) {
            CameraScannerView(scannedCode: $encryptedCode, errorMessage: $cameraErrorMessage)
        }
        .alert("Camera", isPresented: Binding(
            get: { cameraErrorMessage != nil },
            set: { if !$0 { cameraErrorMessage = nil } }
        )) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(cameraErrorMessage ?? "")
        }
    }
}

struct CameraScannerView: UIViewControllerRepresentable {
    @Environment(\.dismiss) private var dismiss
    @Binding var scannedCode: String
    @Binding var errorMessage: String?

    func makeUIViewController(context: Context) -> ScannerViewController {
        let controller = ScannerViewController()
        controller.onCodeScanned = { code in
            scannedCode = code
            dismiss()
        }
        controller.onError = { message in
            errorMessage = message
            dismiss()
        }
        return controller
    }

    func updateUIViewController(_ uiViewController: ScannerViewController, context: Context) { }
}

final class ScannerViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    var onCodeScanned: ((String) -> Void)?
    var onError: ((String) -> Void)?

    private let captureSession = AVCaptureSession()
    private var previewLayer: AVCaptureVideoPreviewLayer?
    private var hasScanned = false

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        configureSession()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        previewLayer?.frame = view.layer.bounds
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if !captureSession.isRunning {
            captureSession.startRunning()
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if captureSession.isRunning {
            captureSession.stopRunning()
        }
    }

    private func configureSession() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            setupCapturePipeline()
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
                DispatchQueue.main.async {
                    guard let self else { return }
                    if granted {
                        self.setupCapturePipeline()
                    } else {
                        self.onError?("Camera permission denied.")
                    }
                }
            }
        default:
            onError?("Camera permission denied. Enable camera access in Settings.")
        }
    }

    private func setupCapturePipeline() {
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else {
            onError?("Camera is not available on this device.")
            return
        }

        guard let videoInput = try? AVCaptureDeviceInput(device: videoCaptureDevice),
              captureSession.canAddInput(videoInput) else {
            onError?("Unable to access the camera input.")
            return
        }
        captureSession.addInput(videoInput)

        let metadataOutput = AVCaptureMetadataOutput()
        guard captureSession.canAddOutput(metadataOutput) else {
            onError?("Unable to scan codes right now.")
            return
        }
        captureSession.addOutput(metadataOutput)
        metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        metadataOutput.metadataObjectTypes = [.qr, .ean8, .ean13, .code128, .pdf417]

        let preview = AVCaptureVideoPreviewLayer(session: captureSession)
        preview.videoGravity = .resizeAspectFill
        preview.frame = view.layer.bounds
        view.layer.addSublayer(preview)
        previewLayer = preview

        captureSession.startRunning()
    }

    func metadataOutput(_ output: AVCaptureMetadataOutput,
                        didOutput metadataObjects: [AVMetadataObject],
                        from connection: AVCaptureConnection) {
        guard !hasScanned,
              let metadataObject = metadataObjects.first as? AVMetadataMachineReadableCodeObject,
              let code = metadataObject.stringValue else {
            return
        }

        hasScanned = true
        captureSession.stopRunning()
        onCodeScanned?(code)
    }
}

#Preview {
    ScanAndInfoView(isLoggedIn: .constant(false))
}
