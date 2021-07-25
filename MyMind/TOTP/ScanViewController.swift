//
//  ScanViewController.swift
//  MyMind
//
//  Created by Barry Chen on 2021/6/28.
//  Copyright © 2021 United Digital Intelligence. All rights reserved.
//
import UIKit
import AVFoundation

protocol ScanViewControllerDelegate: AnyObject {
    func scanViewController(_ scanViewController: ScanViewController, didReceive qrCodeValue: String)
    func scanViewController(_ scanViewController: ScanViewController, validate qrCodeValue: String) -> Bool
}

final class ScanViewController: UIViewController {
    // MARK: - Properties
    private var captureSession: AVCaptureSession?
    private var videoPreviewLayer: ScannerOverlayPreviewLayer?
    private var qrCodeFrameView: UIView?

    weak var delegate: ScanViewControllerDelegate?

    @IBOutlet weak var closeButton: UIButton!
    // MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        let status = AVCaptureDevice.authorizationStatus(for: .video)
        if status != .authorized {
            AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
                DispatchQueue.main.async {
                    if granted {
                        self?.startReading()
                    } else {
                        let alertViewController = UIAlertController(title: "拒絕授權使用", message: "若拒絕授權使用相機，將無法取得驗證碼，請前往設定開啟相機權限", preferredStyle: .alert)
                        let cancelAction = UIAlertAction(title: "取消", style: .cancel) { action in
                            self?.dismiss(animated: true, completion: nil)
                        }
                        let confirmAction = UIAlertAction(title: "設定", style: .default) { action in
                            let url = URL(string: UIApplication.openSettingsURLString)
                            if let url = url, UIApplication.shared.canOpenURL(url) {
                                UIApplication.shared.open(url, options: [:]) { success in
                                }
                            }
                        }
                        alertViewController.addAction(cancelAction)
                        alertViewController.addAction(confirmAction)
                        self?.present(alertViewController, animated: true, completion: nil)
                    }
                }
           }
        } else {
            startReading()
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        let string = "00GXfpCkQp082fcSlkJBinwwvdb2v4AbFJTP1Av4KQQpGJBvBXkt4eSY8HLwW71Dn9kEEZFwiQ9v29wNU9BG0uqCkCcjJOSApG9qyRL5yCRuH749foHk7kkbqvIaDyxgoSVhis0uU3r8o="
//        let string = "00prqa3Y1IJyAAjkavCTMa0//neIbPtOzq0WQ0KFm+50suD+ljTQqpMKQ4iA/j4gxsbZ8fka91SJ9yFmtjzpkHH3Eikvwn4gU4+/Kf8tHmcSPlSXnvFoREa4hNn1+d/zfr"
//        if let delegate = delegate, delegate.scanViewController(self, validate: string) {
//            guard validateMetadataString(string: string) else {
//                showInvalidQRCodeAlert()
//                return
//            }
//            delegate.scanViewController(self, didReceive: string)
//            dismiss(animated: true, completion: nil)
//        } else {
//            showInvalidQRCodeAlert()
//        }
    }
    // MARK: - Methods
    private func startReading() {
        print("start reading")
        guard
            captureSession == nil
        else {
            return
        }
        guard
            let captureDevice = AVCaptureDevice.default(for: .video),
            let input = try? AVCaptureDeviceInput.init(device: captureDevice)
        else {
            return
        }

        captureSession = AVCaptureSession.init()
        captureSession?.addInput(input)

        let captureOutput = AVCaptureMetadataOutput.init()
        captureSession?.addOutput(captureOutput)
        captureOutput.setMetadataObjectsDelegate(self, queue: .main)
        captureOutput.metadataObjectTypes = [.qr]

        configPreviewLayer()

        view.bringSubviewToFront(closeButton)

        captureSession?.startRunning()
    }

    private func configPreviewLayer() {
        guard let session = captureSession else { return }
        videoPreviewLayer = ScannerOverlayPreviewLayer.init(session: session)
        videoPreviewLayer?.backgroundColor = UIColor.black.withAlphaComponent(0.5).cgColor
        videoPreviewLayer?.maskSize = CGSize(width: 160, height: 160)
        videoPreviewLayer?.videoGravity = .resizeAspectFill
        videoPreviewLayer?.frame = view.layer.bounds
        view.layer.addSublayer(videoPreviewLayer!)
    }

    private func stopRunning() {
        captureSession?.stopRunning()
        captureSession = nil

        videoPreviewLayer?.removeFromSuperlayer()
        videoPreviewLayer = nil
    }

    func validateMetadataString(string: String) -> Bool {

        if string.contains(String.udnEncryptePrefix) {
            return true
        } else if string.hasPrefix(.googleOTPPrefix) && string.contains(String.secretIdentityKey) {
            return true
        } else {
            return false
        }
    }

    // MARK: - Actions
    @IBAction private func closeButtonDidTapped() {
        dismiss(animated: true, completion: nil)
    }
}
// MARK: - AV Capture Metadata Output Delegate
extension ScanViewController: AVCaptureMetadataOutputObjectsDelegate {
    func showInvalidQRCodeAlert() {
        let alert = UIAlertController.init(title: nil, message: "無效的 QR 碼", preferredStyle: .alert)
        let action = UIAlertAction.init(title: "確定", style: .default) { [weak self] (_) in
            guard let self = self else { return }
            self.captureSession?.startRunning()
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }

    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        guard
            let metadadaObject = metadataObjects.first as? AVMetadataMachineReadableCodeObject,
            metadadaObject.type == .qr,
            let stringValue = metadadaObject.stringValue
        else { return }
        if let delegate = delegate, delegate.scanViewController(self, validate: stringValue) {
            guard validateMetadataString(string: stringValue) else {
                captureSession?.stopRunning()
                showInvalidQRCodeAlert()
                return
            }
        } else {
            captureSession?.stopRunning()
            showInvalidQRCodeAlert()
            return
        }
        stopRunning()
        delegate?.scanViewController(self, didReceive: stringValue)
        dismiss(animated: true, completion: nil)
    }
}

fileprivate extension String {
    static let googleOTPPrefix: String = "otpauth://totp/"
    static let secretIdentityKey: String = "secret"
    static let udnEncryptePrefix: String = "00"
}
