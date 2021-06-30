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
    @IBOutlet private weak var introduceLabel: UILabel!
    @IBOutlet var cameraBarButton: UIBarButtonItem!
    private var instructionView: InstructionView?

    // MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = UIColor.groupTableViewBackground
        tableView.backgroundColor = UIColor.groupTableViewBackground
        tableView.register(SecretTableViewCell.nib, forCellReuseIdentifier: SecretTableViewCell.reuseIdentifier)

        addCustomViewForCameraBarButtonItem()

        if repository.secrets.isEmpty {
            showInstructionView()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        switch repository.secrets.isEmpty {
        case true: showIntroduceLabel()
        case false:
            removeInstructionView()
            hideIntroduceLabel()
        }
    }

    // MARK: - Methods
    // For animation purpose
    private func addCustomViewForCameraBarButtonItem() {
        let image = UIImage(named: "camera")
        let button = UIButton()
        button.setImage(image, for: .normal)
        button.tintColor = .systemOrange
        button.addTarget(self, action: #selector(cameraBarButtonDidTapped), for: .touchUpInside)
        cameraBarButton.customView = button
    }

    private func showInstructionView() {
        guard instructionView == nil else { return }
        instructionView = InstructionView()

        self.navigationController?.view.addSubview(instructionView!)
        instructionView!.confirmButton.addTarget(self, action: #selector(cameraBarButtonDidTapped), for: .touchUpInside)
        instructionView!.frame = UIScreen.main.bounds
        instructionView!.layoutIfNeeded()
    }

    private func removeInstructionView() {
        instructionView?.removeFromSuperview()
        instructionView = nil
    }

    private func showIntroduceLabel() {
        introduceLabel.isHidden = false
        animateCameraButton()
    }

    private func hideIntroduceLabel() {
        introduceLabel.isHidden = true
        cameraBarButton.customView?.layer.removeAnimation(forKey: "scale")
    }

    private func animateCameraButton() {
        cameraBarButton.customView?.layer.removeAnimation(forKey: "scale")
        let scaleAnimation = CABasicAnimation(keyPath: "transform.scale")
        scaleAnimation.fromValue = 1
        scaleAnimation.toValue = 1.5
        scaleAnimation.duration = 1
        scaleAnimation.autoreverses = true
        scaleAnimation.repeatCount = .greatestFiniteMagnitude

        cameraBarButton.customView?.layer.add(scaleAnimation, forKey: "scale")
    }

    // MARK: - Actions
    @IBAction private func infoBarButtonDidTapped() {
        let viewController = InformationTableViewController(style: .grouped)
        navigationController?.show(viewController, sender: nil)
    }

    @objc
    private func cameraBarButtonDidTapped() {
        guard let viewController = storyboard?.instantiateViewController(withIdentifier: "ScanViewController") as? ScanViewController else {
            return
        }
        viewController.delegate = self
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
        let secret = repository.secrets[indexPath.row]
        cell.config(with: secret)
        return cell
    }
}
// MARK: - Table view delegate
extension SecretListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 74
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }

        tableView.beginUpdates()
        repository.deleteSecret(at: indexPath.section)
        try? repository.saveSecrets()
        tableView.deleteSections([indexPath.section], with: .automatic)
        tableView.endUpdates()

        if repository.secrets.isEmpty {
            showIntroduceLabel()
        }
    }
}
