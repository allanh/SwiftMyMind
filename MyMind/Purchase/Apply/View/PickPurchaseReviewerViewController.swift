//
//  PickPurchaseReviewerViewController.swift
//  MyMind
//
//  Created by Barry Chen on 2021/6/10.
//  Copyright © 2021 United Digital Intelligence. All rights reserved.
//

import UIKit
import RxSwift

final class PickPurchaseReviewerViewController: UIViewController {

    @IBOutlet weak var pickReviewerTitleLabel: UILabel!
    @IBOutlet weak var pickReviewerTitleLableHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var pickerReviewerTitleLabelBottomConstraint: NSLayoutConstraint!
    @IBOutlet private weak var pickReviewerTextField: CustomClearButtonPositionTextField!
    @IBOutlet weak var pickReviewerTextFieldHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var pickReviewerErrorLabel: UILabel!
    @IBOutlet weak var noteTextViewTopConstraint: NSLayoutConstraint!
    @IBOutlet private weak var noteTextView: UITextView!
    @IBOutlet private weak var noteErrorLabel: UILabel!
    @IBOutlet private weak var noteTextCounterLabel: UILabel!
    @IBOutlet private weak var logInfosStackView: UIStackView!

    lazy var dropDownView: DropDownView<Reviewer, DropDownListTableViewCell> = {
        let dropDownView = DropDownView(dataSource: []) { (cell: DropDownListTableViewCell, item) in
            self.configDropDownCell(cell: cell, with: item)
        } selectHandler: { item in
            self.selectedReviewer(item)
        }
        return dropDownView
    }()

    var viewModel: PickPurchaseReviewerViewModel!
    let bag: DisposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        configureRootView()
        if viewModel.isLastReview {
            hideReviewerPicker()
        } else {
            configurePickReviewerTextField()
        }
        configureDropDownView()
        configureLogInfosViews()
        viewModel.loadPurchaseReviewerList()
        bindToViewModel()
        subscribeViewModel()
    }

    private func bindToViewModel() {
        noteTextView.rx.text
            .orEmpty
            .bind(to: viewModel.note)
            .disposed(by: bag)
    }

    private func subscribeViewModel() {
        viewModel.reviewerList
            .subscribe(onNext: { [unowned self] reviewers in
                self.dropDownView.dataSource = reviewers
            })
            .disposed(by: bag)

        viewModel.pickedReviewer
            .map({ $0?.account })
            .bind(to: pickReviewerTextField.rx.text)
            .disposed(by: bag)

        viewModel.note
            .map({ "\($0.count)/200" })
            .bind(to: noteTextCounterLabel.rx.text)
            .disposed(by: bag)

        viewModel.pickedReviewerValidationStatus
            .skip(1)
            .subscribe(onNext: { [unowned self] status in
                self.updatePickReviewerTextFieldLayout(with: status)
            })
            .disposed(by: bag)

        viewModel.noteValidationStatus
            .subscribe(onNext: { [unowned self] status in
                self.updateNoteTextViewLayout(with: status)
            })
            .disposed(by: bag)
    }

    private func configureRootView() {
        view.layer.cornerRadius = 4
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.separator.cgColor
    }

    private func hideReviewerPicker() {
        pickReviewerTitleLableHeightConstraint.constant = 0
        pickerReviewerTitleLabelBottomConstraint.constant = 0
        pickReviewerTextFieldHeightConstraint.constant = 0
        noteTextViewTopConstraint.constant = 0
    }
    private func configurePickReviewerTextField() {
        let formatter = NumberFormatter()
        formatter.locale = Locale(identifier: "zh_Hant")
        formatter.numberStyle = .spellOut
        let level: String = formatter.string(from: viewModel.level as NSNumber) ?? ""
        let attributedString = NSMutableAttributedString(string: "*選擇\(level)審人員", attributes: [.foregroundColor: UIColor.label])
        attributedString.addAttributes([.foregroundColor : UIColor.red], range: NSRange(location:0,length:1))
        pickReviewerTitleLabel.attributedText = attributedString
        pickReviewerTextField.delegate = self
        pickReviewerTextField.layer.borderWidth = 1
        pickReviewerTextField.layer.borderColor = UIColor.separator.cgColor
        pickReviewerTextField.layer.cornerRadius = 4
        pickReviewerTextField.setLeftPaddingPoints(10)
        pickReviewerTextField.font = .pingFangTCRegular(ofSize: 14)
        pickReviewerTextField.textColor = UIColor(hex: "4c4c4c")
    }

    private func updatePickReviewerTextFieldLayout(with validationStatus: ValidationResult) {
        switch validationStatus {
        case .valid:
            pickReviewerTextField.layer.borderColor = UIColor.init(hex: "cccccc").cgColor
            pickReviewerErrorLabel.isHidden = true
        case .invalid(let message):
            pickReviewerTextField.layer.borderColor = UIColor.systemRed.cgColor
            pickReviewerErrorLabel.text = message
            pickReviewerErrorLabel.isHidden = false
        }
    }

    private func updateNoteTextViewLayout(with validationStatus: ValidationResult) {
        switch validationStatus {
        case .valid:
            noteTextView.layer.borderColor = UIColor.init(hex: "cccccc").cgColor
            noteErrorLabel.isHidden = true
        case .invalid(let message):
            noteTextView.layer.borderColor = UIColor.systemRed.cgColor
            noteErrorLabel.text = message
            noteErrorLabel.isHidden = false
        }
    }

    private func configureDropDownView() {
        dropDownView.topInset = 5
        dropDownView.anchorView = pickReviewerTextField
    }

    private func configDropDownCell(cell: DropDownListTableViewCell, with item: Reviewer) {
        cell.titleLabel.text = item.account
    }

    private func selectedReviewer(_ reviewer: Reviewer) {
        viewModel.pickedReviewer.accept(reviewer)
        dropDownView.hide()
    }

    private func makeLogInfoView(with logInfo: PurchaseOrder.LogInfo) -> LogInfoView {
        let logInfoView = LogInfoView()
        logInfoView.configure(with: logInfo)
        return logInfoView
    }

    private func configureLogInfosViews() {
        guard let logInfos = viewModel.logInfos else { return }
        logInfos.forEach {
            let logInfoView = makeLogInfoView(with: $0)
            logInfosStackView.addArrangedSubview(logInfoView)
        }
    }
}

extension PickPurchaseReviewerViewController: UITextFieldDelegate {

    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        dropDownView.show()
        return false
    }
}
