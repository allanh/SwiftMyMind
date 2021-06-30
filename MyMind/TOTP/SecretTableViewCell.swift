//
//  SecretTableViewCell.swift
//  UDIAuthorizer
//
//  Created by Barry Chen on 2021/1/18.
//

import UIKit

final class SecretTableViewCell: UITableViewCell {
    // MARK: - Properties
    static var reuseIdentifier: String {
        return String(describing: self)
    }

    static var nib: UINib {
        return UINib(nibName: String(describing: self), bundle: nil)
    }

    @IBOutlet weak var pinLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var registerDateLabel: UILabel!

    var timer: Timer?
    var secret: Secret?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        timer?.invalidate()
        timer = nil
    }
    // MARK: - Methods
    func config(with secret: Secret) {
        self.secret = secret

        updatePin()
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updatePin), userInfo: nil, repeats: true)
        timer?.fire()

        userNameLabel.text = secret.user

        if let date = secret.registerDate {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let dateString = dateFormatter.string(from: date)
            registerDateLabel.text = dateString
        } else {
            registerDateLabel.text = ""
        }
    }

    @objc
    private func updatePin() {
        guard let secret = self.secret else { return }
        var pin = secret.generatePin()

        guard pin.count == 6 else { return }

        let index = pin.index(pin.startIndex, offsetBy: 3)
        pin.insert(contentsOf: "  ", at: index)
        pinLabel.text = pin

        let validColor: UIColor = UIColor(red: 1.0, green: 127.0/255.0, blue: 0.0, alpha: 1.0)
        let inValidColor: UIColor = UIColor(white: 0.7, alpha: 1.0)

        progressView.progressTintColor = secret.isValid ? validColor : inValidColor
        pinLabel.textColor = secret.isValid ? validColor : inValidColor

        let calendar: Calendar = Calendar.current
        let second: Int = calendar.component(.second, from: Date())

        let timeBase: Float = 60
        let progress = (timeBase - Float(second)) / timeBase

        progressView.setProgress(progress, animated: true)

        if progress < 0.33 && secret.isValid {
            pinLabel.textColor = .systemRed
            progressView.progressTintColor = .systemRed
        }
    }
}
