//
//  ViewController.swift
//  UDIAuthorizer
//
//  Created by Barry Chen on 2021/1/14.
//

import UIKit

class SecretListViewController: UIViewController {
    // MARK: - Properties
    let repository: UDISecretRepository = UDISecretRepository(dataStore: UserDefaultSecretDataStore.init())

    @IBOutlet private weak var tableView: UITableView!
    private var instructionView: MyMindInstructionView?
    private var emptySecretView: MyMindEmptySecretView?
    weak var scanViewControllerDelegate: ScanViewControllerDelegate?

    // MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let navigationTitleImageView: UIImageView = UIImageView {
            $0.image = UIImage(named: "udi_logo")
        }
        navigationItem.titleView = navigationTitleImageView
        tableView.register(SecretTableViewCell.nib, forCellReuseIdentifier: SecretTableViewCell.reuseIdentifier)
        
        if repository.secrets.isEmpty {
            showInstructionView()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        switch repository.secrets.isEmpty {
        case true:
            if instructionView?.superview != nil {
                hideCameraButton()
            } else {
                showEmptySecretView()
                showCameraButton()
            }
        case false:
            removeInstructionView()
            hideEmptySecretView()
            showCameraButton()
        }
    }
    
    private let cameraButton: UIButton = UIButton {
        $0.setImage(UIImage(named: "camera")?.withRenderingMode(.alwaysTemplate), for: .normal)
        $0.layer.cornerRadius = 24
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = UIColor(hex:"ff7d2c")
        $0.tintColor = .white
        $0.addTarget(self, action: #selector(cameraBarButtonDidTapped), for: .touchUpInside)
    }
    // MARK: - Methods
    // For animation purpose
    private func showCameraButton() {
        view.addSubview(cameraButton)
        cameraButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        cameraButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20).isActive = true
        cameraButton.widthAnchor.constraint(equalToConstant: 48).isActive = true
        cameraButton.heightAnchor.constraint(equalToConstant: 48).isActive = true
    }

    private func hideCameraButton() {
        cameraButton.removeFromSuperview()
    }
    private func showInstructionView() {
        guard instructionView == nil else { return }
        instructionView = MyMindInstructionView()

        view.addSubview(instructionView!)
        instructionView?.topAnchor.constraint(equalTo: view.topAnchor, constant: 40).isActive = true
        instructionView?.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25).isActive = true
        instructionView?.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25).isActive = true
        instructionView?.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -40).isActive = true
        
        instructionView!.confirmButton.addTarget(self, action: #selector(cameraBarButtonDidTapped), for: .touchUpInside)
        instructionView!.layoutIfNeeded()
    }

    private func removeInstructionView() {
        instructionView?.removeFromSuperview()
        instructionView = nil
    }

    private func showEmptySecretView() {
        guard emptySecretView == nil else { return }
        emptySecretView = MyMindEmptySecretView()

        if cameraButton.superview != nil {
            view.insertSubview(emptySecretView!, belowSubview: cameraButton)
        } else {
            view.addSubview(emptySecretView!)
        }
        emptySecretView?.topAnchor.constraint(equalTo: view.topAnchor, constant: 40).isActive = true
        emptySecretView?.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25).isActive = true
        emptySecretView?.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25).isActive = true
        emptySecretView?.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -40).isActive = true
        emptySecretView?.layoutIfNeeded()
    }
    
    private func hideEmptySecretView() {
        emptySecretView?.removeFromSuperview()
        emptySecretView = nil
    }
    
    // MARK: - Actions
    @IBAction
    private func closeButtonDidTapped(_ sender: Any) {
        navigationController?.dismiss(animated: true, completion: nil)
    }
    @objc
    private func cameraBarButtonDidTapped() {
        guard let viewController = storyboard?.instantiateViewController(withIdentifier: "ScanViewController") as? ScanViewController else {
            return
        }
        viewController.delegate = (scanViewControllerDelegate != nil) ? scanViewControllerDelegate : self
        present(viewController, animated: true, completion: nil)
    }

}
// MARK: - Scan view controller delegate
extension SecretListViewController: ScanViewControllerDelegate {
    func scanViewController(_ scanViewController: ScanViewController, didReceive qrCodeValue: String) {
        if let url = URL(string: qrCodeValue),
           let secret = Secret.init(url: url) {
            updateAndSaveSecret(secret: secret)
        } else if let secret = Secret.generateSecret(with: qrCodeValue) {
            updateAndSaveSecret(secret: secret)
        }
    }

    private func updateAndSaveSecret(secret: Secret) {
        repository.update(newSecrets: secret)
        try? repository.saveSecrets()
        tableView.reloadData()
    }
    func scanViewController(_ scanViewController: ScanViewController, validate qrCodeValue: String) -> Bool {
        return true
    }
}
// MARK: - Table view data source
extension SecretListViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return repository.secrets.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SecretTableViewCell.reuseIdentifier, for: indexPath) as? SecretTableViewCell else {
            fatalError("dequeue SecretTableViewCell failed")
        }
        let secret = repository.secrets[indexPath.section]
        cell.config(with: secret)
        return cell
    }
}
// MARK: - Table view delegate
extension SecretListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 114
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: nil) { (_, _, completionHandler) in
            let alertViewController = UIAlertController(title: "確定移除驗證碼？", message: "點擊確定後此驗證碼將被移除，若要再次取得驗證碼，需重新掃描 QR Code", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "取消", style: .cancel) { action in
                self.dismiss(animated: true, completion: nil)
            }
            let confirmAction = UIAlertAction(title: "確定", style: .default) { action in
                tableView.beginUpdates()
                self.repository.deleteSecret(at: indexPath.section)
                try? self.repository.saveSecrets()
                tableView.deleteSections([indexPath.section], with: .left)
                tableView.endUpdates()

                if self.repository.secrets.isEmpty {
                    self.showEmptySecretView()
                }
                completionHandler(true)
            }
            alertViewController.addAction(cancelAction)
            alertViewController.addAction(confirmAction)
            self.present(alertViewController, animated: true, completion: nil)
        }
        deleteAction.image = UIImage(systemName: "trash")
        deleteAction.backgroundColor = UIColor(hex: "ea6120")
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        return configuration
    }
    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }
}
