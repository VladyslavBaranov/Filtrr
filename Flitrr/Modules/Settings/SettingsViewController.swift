//
//  SettingsViewController.swift
//  Flitrr
//
//  Created by Vladyslav Baranov on 20.04.2022.
//

import SwiftUI
import StoreKit

final class SettingsTableCell: UITableViewCell {
    
    enum CustomAccessoryType {
        case disclosure
        case checkmark
        case none
    }
    
    var customAccessoryType: CustomAccessoryType = .disclosure {
        didSet {
            switch customAccessoryType {
            case .none:
                trailingImageView.image = UIImage()
            case .disclosure:
                trailingImageView.image = UIImage(systemName: "chevron.right")
            case .checkmark:
                trailingImageView.image = UIImage(named: "Checkbox")
            }
        }
    }
    
    var trailingImageView: UIImageView!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        textLabel?.font = UIFont(name: "Montserrat-Regular", size: 17)
        trailingImageView = UIImageView(image: UIImage(systemName: "chevron.right"))
        trailingImageView.tintColor = .appGray
        trailingImageView.contentMode = .scaleAspectFit
        addSubview(trailingImageView)
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        textLabel?.frame.origin.x = 40
        trailingImageView?.frame.origin.x = bounds.width - 60
        trailingImageView.frame.origin.y = bounds.height / 3
        trailingImageView.frame.size = .init(width: bounds.height / 3, height: bounds.height / 3)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

final class PaywallThumbnailView: UIView {
    
    var isCompact = false
    var premiumLabel: UILabel!
    var premiumView: PremiumViewTitle!
    
    var womanImageView: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        womanImageView = UIImageView(image: .init(named: "CompactWoman"))
        womanImageView.backgroundColor = .black
        addSubview(womanImageView)
        womanImageView.frame = bounds
        setupPremiumLabel()
        
        premiumView = PremiumViewTitle()
        addSubview(premiumView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        womanImageView.frame = .init(x: 0, y: 0, width: bounds.width, height: bounds.height - 80)
        premiumView.frame = .init(x: 0, y: bounds.height - 80, width: bounds.width, height: 80)
        premiumLabel.frame = .init(x: 16, y: bounds.height - 140, width: bounds.width - 16, height: 60)
        layer.cornerRadius = 10
        clipsToBounds = true
        
    }
    
    func setupPremiumLabel() {
        premiumLabel = UILabel()
        let string = NSMutableAttributedString()
        let filtrrString = NSAttributedString(string: "filtrr", attributes: [
			.font: Montserrat.bold(size: 20)
        ])
        string.append(filtrrString)
        let premiumString = NSAttributedString(string: " premium", attributes: [
			.font: Montserrat.light(size: 20)
        ])
        string.append(premiumString)
        premiumLabel.attributedText = string
        premiumLabel.textColor = .white
        addSubview(premiumLabel)
    }
}

final class PremiumViewTitle: UIView {
    var label: UILabel!
    var chevronImageView: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .appGray
        label = UILabel()
		label.text = LocalizationManager.shared.localizedString(for: .settingsCardCaption)
		label.font = Montserrat.light(size: 13)
        addSubview(label)
        label.numberOfLines = 2
        label.textColor = .soft2
        
        chevronImageView = UIImageView()
        chevronImageView.image = UIImage(systemName: "chevron.forward")
        chevronImageView.tintColor = .soft2
        chevronImageView.contentMode = .scaleAspectFit
        addSubview(chevronImageView)
    }
    
    func localize() {
        label.text = LocalizationManager.shared.localizedString(for: .settingsCardCaption)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        label.frame = .init(x: 17, y: 0, width: bounds.width - 97, height: bounds.height)
        chevronImageView.frame = .init(x: bounds.width - 25, y: bounds.height - 30, width: 10, height: 20)
    }
}

final class ThumbnailTableHeaderView: UIView {

    var thumb: PaywallThumbnailView!
    
    var onPaywallTap: (() -> ())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        thumb = PaywallThumbnailView()
        addSubview(thumb)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        thumb.frame = bounds.insetBy(dx: 30, dy: 30)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        onPaywallTap?()
    }
}

final class SettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    struct SettingsItem {
        enum IType { case appearance, language, restore, privacy, rate }
        var title: String
        var type: IType
    }

    var toolBarView: ToolBarView!
    var tableView: UITableView!
    var thumbnailView: PaywallThumbnailView!
    
    var settingsItems: [SettingsItem] = [
        .init(title: LocalizationManager.shared.localizedString(for: .settingsAppearance), type: .appearance),
        .init(title: LocalizationManager.shared.localizedString(for: .settingsLang), type: .language),
        .init(title: LocalizationManager.shared.localizedString(for: .settingsRestore), type: .restore),
        .init(title: LocalizationManager.shared.localizedString(for: .settingsPrivacy), type: .privacy),
        .init(title: LocalizationManager.shared.localizedString(for: .settingsRate), type: .rate)
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .appDark
 
        tableView = UITableView(frame: view.bounds, style: .plain)
        tableView.backgroundColor = .appDark
        view.addSubview(tableView)
        tableView.register(SettingsTableCell.self, forCellReuseIdentifier: "id")
        tableView.delegate = self
        tableView.dataSource = self
    
        if !StoreObserver.shared.isSubscribed() {
            let thumb = ThumbnailTableHeaderView(frame: .init(x: 0, y: 0, width: view.bounds.width, height: view.bounds.width * 0.9))
            thumb.onPaywallTap = presentPaywall
            tableView.tableHeaderView = thumb
            tableView.separatorInset = .init(top: 80, left: 30, bottom: 0, right: 30)
            settingsItems.remove(at: 2)
        }
        setupToolBar()
        
        tableView.contentInset = .init(
            top: UIApplication.shared.getStatusBarHeight() + 40, left: 0, bottom: 0, right: 0)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        localize()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        settingsItems.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        70
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "id", for: indexPath)
        cell.selectionStyle = .none
        cell.textLabel?.text = settingsItems[indexPath.row].title
        cell.backgroundColor = .clear
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = indexPath.row
        let itemType = settingsItems[row].type
        
        switch itemType {
        case .appearance:
            let vc = AppearanceViewController()
            vc.modalPresentationStyle = .fullScreen
            present(vc, animated: true)
        case .rate:
            if let scene = view.window?.windowScene {
                SKStoreReviewController.requestReview(in: scene)
            }
        case .privacy:
            let privacyPolicyVC = PrivacyPolicyViewController()
            privacyPolicyVC.modalPresentationStyle = .fullScreen
            present(privacyPolicyVC, animated: true)
        case .language:
            let languageVC = LanguageTableViewController()
            languageVC.modalPresentationStyle = .fullScreen
            present(languageVC, animated: true)
        case .restore:
            StoreObserver.shared.restore()
        }
    }
    
    func presentPaywall() {
        let controller = PaywallHostingController(rootView: PaywallView())
        controller.modalPresentationStyle = .fullScreen
        present(controller, animated: true)
    }
    
    func setupToolBar() {
        toolBarView = ToolBarView(frame: .zero, centerItem: .editSet)
        toolBarView.delegate = self
        toolBarView.centerItem = .title
        toolBarView.trailingItem = .none
        toolBarView.title = LocalizationManager.shared.localizedString(for: .settingsTitle)
        toolBarView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(toolBarView)
        
        NSLayoutConstraint.activate([
            toolBarView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            toolBarView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            toolBarView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            toolBarView.heightAnchor.constraint(equalToConstant: 80)
        ])
    }
    
    @objc func dismissSelf() {
        dismiss(animated: true)
    }
    
    static func createSettingsNavigationController() -> SettingsViewController {
        let controller = SettingsViewController()
        return controller
    }
    
    func localize() {
        thumbnailView?.premiumView.localize()
        navigationItem.title = LocalizationManager.shared.localizedString(for: .settingsTitle)
        settingsItems = [
            .init(title: LocalizationManager.shared.localizedString(for: .settingsAppearance), type: .appearance),
            .init(title: LocalizationManager.shared.localizedString(for: .settingsLang), type: .language),
            .init(title: LocalizationManager.shared.localizedString(for: .settingsRestore), type: .restore),
            .init(title: LocalizationManager.shared.localizedString(for: .settingsPrivacy), type: .privacy),
            .init(title: LocalizationManager.shared.localizedString(for: .settingsRate), type: .rate)
        ]
        if StoreObserver.shared.isSubscribed() {
            settingsItems.remove(at: 2)
        }
        tableView?.reloadData()
    }
}

extension SettingsViewController: ToolBarViewDelegate {
    func didTapTrailingItem() {}
    
    func didTapLeadingItem() {
        dismiss(animated: true)
    }
    
    func didTapUndo() {}
    func didTapLayers() {}
    func didTapRedo() {}
}
