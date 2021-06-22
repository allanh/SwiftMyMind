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

    @IBOutlet private weak var pickReviewerTextField: CustomClearButtonPositionTextField!
    @IBOutlet private weak var pickReviewerErrorLabel: UILabel!
    @IBOutlet private weak var noteTextView: UITextView!
    @IBOutlet private weak var noteErrorLabel: UILabel!
    @IBOutlet private weak var noteTextCounterLabel: UILabel!

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
        configurePickReviewerTextField()
        configureDropDownView()
        viewModel.fetchPurchaseReviewerList()
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

    private func configurePickReviewerTextField() {
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
}

extension PickPurchaseReviewerViewController: UITextFieldDelegate {

    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        dropDownView.show()
        return false
    }
}
