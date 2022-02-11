//
//  CategoryViewController.swift
//  MyMind
//
//  Created by Nelson Chan on 2021/10/8.
//  Copyright © 2021 United Digital Intelligence. All rights reserved.
//

import UIKit
protocol CategoryViewControllerDelegate: AnyObject {
    func categoryViewController(_: CategoryViewController, didSelect category: Category)
}
protocol Category {
    var title: String { get }
    var imageName: String? { get }
}
class CategoryViewController: UIViewController {
    typealias CategoryInfo = (title: String, image: String?)
    let scrollView: UIScrollView = UIScrollView {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.automaticallyAdjustsScrollIndicatorInsets = false
    }
    private var items: [Category] = []
    private var buttons: [UIButton] = []
    var insets: UIEdgeInsets = .zero
    var interspacing: CGFloat = 0
    var font: UIFont = .systemFont(ofSize: 16)
    var itemInsets: UIEdgeInsets = .zero
    weak var delegate: CategoryViewControllerDelegate?
    var selectedIndex: Int = 0 {
        didSet {
            if oldValue != selectedIndex, buttons.count > selectedIndex {
                let current = items[selectedIndex]
                if let _ = current.imageName {
                    buttons[selectedIndex].tintColor = .white
                }
                let previous = items[oldValue]
                if let _ = previous.imageName {
                    buttons[oldValue].tintColor = .brownGrey
                }
                buttons[oldValue].isSelected = false
                buttons[oldValue].backgroundColor = .white
                buttons[selectedIndex].isSelected = true
                buttons[selectedIndex].backgroundColor = .prussianBlue
                delegate?.categoryViewController(self, didSelect: items[selectedIndex])
            }
        }
    }
    convenience init(items: [Category]) {
        self.init()
        self.items = items
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.addSubview(scrollView)
            constructButtons()
        activateConstraintsScrollView()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let last = buttons.last {
            scrollView.contentSize = CGSize(width: last.frame.maxX+insets.right, height: view.bounds.height)
        } else {
            scrollView.contentSize = CGSize(width: view.bounds.width, height: view.bounds.height)
        }
    }
    @objc
    private func toggleCategory(_ sender: UIButton) {
        selectedIndex = buttons.firstIndex(of: sender)!
    }
    private func constructButtons() {
        var previousButton: UIButton?
        for (index, item) in items.enumerated() {
            let button = UIButton()
            button.addTarget(self, action: #selector(toggleCategory(_:)), for: .touchUpInside)
            button.setTitle(item.title, for: .normal)
            button.titleLabel?.font = font
            if let image = item.imageName {
                button.setImage(UIImage(named: image)?.withRenderingMode(.alwaysTemplate), for: .normal)
                button.setImage(UIImage(named: image)?.withRenderingMode(.alwaysTemplate), for: .selected)
                button.imageEdgeInsets = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
                button.imageView?.contentMode = .scaleAspectFit
            }
            button.setTitleColor(.white, for: .selected)
            button.setTitleColor(.brownGrey, for: .normal)
            button.tintColor = (index == selectedIndex) ? .white : .brownGrey
            button.isSelected = (index == selectedIndex)
            button.backgroundColor = (index == selectedIndex) ? .prussianBlue : .white
            button.layer.cornerRadius = 16
            button.translatesAutoresizingMaskIntoConstraints = false
            scrollView.addSubview(button)
            if let previousButton = previousButton {
                button.leadingAnchor.constraint(equalTo: previousButton.trailingAnchor, constant: interspacing).isActive = true
            } else {
                button.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: insets.left).isActive = true
            }
            button.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: insets.top).isActive = true
            button.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -insets.bottom).isActive = true
            let lineHeight = "line".height(withConstrainedWidth: .greatestFiniteMagnitude, font: font)
            let width = item.title.width(withConstrainedHeight: lineHeight, font: font) + itemInsets.left + itemInsets.right + ((item.imageName == nil) ? 0 : 20)
            button.widthAnchor.constraint(equalToConstant: width).isActive = true
            buttons.append(button)
            previousButton = button
        }
        view.setNeedsLayout()
        view.layoutIfNeeded()
    }
    private func activateConstraintsScrollView() {
        let top = scrollView.topAnchor.constraint(equalTo: view.topAnchor)
        let centerX = scrollView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        let width = scrollView.widthAnchor.constraint(equalTo: view.widthAnchor)
        let height = scrollView.heightAnchor.constraint(equalTo: view.heightAnchor)
        NSLayoutConstraint.activate([
            centerX, top, width, height
        ])
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
