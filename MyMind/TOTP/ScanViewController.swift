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
    private var isNetworkProcessing: Bool = false {
        didSet {
            switch isNetworkProcessing {
            case true: startAnimatingActivityIndicator()
            case false: stopAnimatinActivityIndicator()
            }
        }
    }

//    @IBOutlet weak var closeButton: UIButton!
    // MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "My Mind 買賣 OTP"
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
//        let string = "00yIC3PIZ/ZScC5Vwg2TFR8eXhKfZhVSSc/mtYJI8MAgp+wBxdIFvW17oMMLlSK7Ho5qtI2HuTMz2sQh8fmAY2hU2UPIOTPv5p+QuLVtvN1AS8nK56Gh/wH32KXXDS21Xl"// production sam lai
//        let string = "00ADB1iGsn1jvWxnGtKSoj59plRI10N/ok6DN8i5qX3neupnFdmvnN6ti9ADusrV6Uy9lzyOpbYOkx4zimcgUjgikFBp8QIBV3Y3QyeyjhbLfbZubDfpzPljuHQjjWIziv"// alpha
//        let string = "00yIC3PIZ/ZScC5Vwg2TFR8eXhKfZhVSScBz5kHxqXZQb8hgFv2wbX4lj/fHdxZkeyYj0MIzgvuarqv/sWbKLTl6Kzwi4GOk/TVXSqPiGm7UYHasOKQQ7v4B9jBeDrSEQuA3ffWbi7h6Q=" // demo
//        let string = "00prqa3Y1IJyAAjkavCTMa0//neIbPtOzq0WQ0KFm+50suD+ljTQqpMKQ4iA/j4gxsbZ8fka91SJ9yFmtjzpkHH3Eikvwn4gU4+/Kf8tHmcSPlSXnvFoREa4hNn1+d/zfr" //production
//        handleReceive(string)
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
    private func showInvalidQRCodeAlert(title: String?, message: String?) {
        let alert = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction.init(title: "確定", style: .default) { [weak self] (_) in
            guard let self = self else { return }
            self.captureSession?.startRunning()
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }

    private func handleReceive(_ value: String) {
        do {
            captureSession?.stopRunning()
            let uuid = try KeychainHelper.default.readItem(key: .uuid, valueType: String.self)
            if let delegate = delegate, delegate.scanViewController(self, validate: value) {
                var scaned: Secret?
                if let url = URL(string: value),
                   let secret = Secret.init(url: url) {
                    scaned = secret
                } else if let secret = Secret.generateSecret(with: value) {
                    scaned = secret
                }
                if let scaned = scaned {
                    let authService = MyMindAuthService()
                    isNetworkProcessing = true
                    authService.binding(info: BindingInfo(uuid: uuid, id: scaned.id, account: scaned.user))
                        .done {
                            self.stopRunning()
                            delegate.scanViewController(self, didReceive: value)
                            self.navigationController?.popViewController(animated: true)
                        }
                        .ensure { self.isNetworkProcessing = false }
                        .catch { error in
                            self.showInvalidQRCodeAlert(title: "App ID 不相符", message: error.localizedDescription)
                        }
                }
            }
        } catch {
            ToastView.showIn(self, message: error.localizedDescription)
            captureSession?.stopRunning()
        }
    }
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        guard
            let metadadaObject = metadataObjects.first as? AVMetadataMachineReadableCodeObject,
            metadadaObject.type == .qr,
            let stringValue = metadadaObject.stringValue
        else { return }
        guard validateMetadataString(string: stringValue) else {
            captureSession?.stopRunning()
            showInvalidQRCodeAlert(title: "無效的 QR Code", message: "請再次確認掃描的 QR Code 是否正確，並點選確定後重新掃描")
            return
        }
        handleReceive(stringValue)
    }
}

fileprivate extension String {
    static let googleOTPPrefix: String = "otpauth://totp/"
    static let secretIdentityKey: String = "secret"
    static let udnEncryptePrefix: String = "00"
}
