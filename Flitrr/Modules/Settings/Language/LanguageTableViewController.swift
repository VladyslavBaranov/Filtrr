//
//  LanguageTableViewController.swift
//  Flitrr
//
//  Created by Vladyslav Baranov on 22.04.2022.
//

import UIKit

final class LanguageTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var tableView: UITableView!
    var toolBarView: ToolBarView!
    
    struct SettingsItem {
        var lang: String
        var isSelected = false
        var id = "en"
    }
    
    var languages: [SettingsItem] = [
        .init(lang: "English", id: "en"),
        .init(lang: "Española", id: "es"),
        .init(lang: "中国人", id: "zh-Hans"),
        .init(lang: "日本", id: "ja"),
        .init(lang: "Français", id: "fr"),
        .init(lang: "Українська", id: "uk"),
        .init(lang: "Deutsch", id: "de"),
        .init(lang: "Русский", id: "ru"),
        .init(lang: "Português", id: "pt-PT"),
        .init(lang: "Italiano", id: "it"),
        .init(lang: "한국인", id: "ko")
    ]

    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        for (i, lang) in languages.enumerated() {
            if lang.id == LocalizationManager.shared.locale {
                languages[i].isSelected = true
            }
        }
        
        view.backgroundColor = .appDark
        
        tableView = UITableView(frame: view.bounds, style: .plain)
        tableView.tableHeaderView = UIView()
        tableView.backgroundColor = .appDark
        
        tableView.register(SettingsTableCell.self, forCellReuseIdentifier: "id")
        tableView.separatorInset = .init(top: 0, left: 30, bottom: 0, right: 30)
        tableView.contentInset = .init(top: 80, left: 0, bottom: 0, right: 0)
        
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
        
        setupToolBar()
    }
    
    func setupToolBar() {
        toolBarView = ToolBarView(frame: .zero, centerItem: .editSet)
        toolBarView.delegate = self
        toolBarView.centerItem = .title
        toolBarView.trailingItem = .none
        toolBarView.title = LocalizationManager.shared.localizedString(for: .settingsLang)
        toolBarView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(toolBarView)
        
        NSLayoutConstraint.activate([
            toolBarView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            toolBarView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            toolBarView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            toolBarView.heightAnchor.constraint(equalToConstant: 80)
        ])
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let lang = languages[indexPath.row]
        for i in 0..<languages.count {
            self.languages[i].isSelected = lang.lang == self.languages[i].lang
        }
        LocalizationManager.shared.locale = lang.id
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "id", for: indexPath) as! SettingsTableCell
        let lang = languages[indexPath.row]
        cell.selectionStyle = .none
        cell.textLabel?.text = lang.lang
        cell.customAccessoryType = lang.isSelected ? .checkmark : .none
        cell.backgroundColor = .clear
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        70
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        languages.count
    }
}

extension LanguageTableViewController: ToolBarViewDelegate {
    func didTapTrailingItem() {
        dismiss(animated: true)
    }
    
    func didTapLeadingItem() {
        dismiss(animated: true)
    }
    
    func didTapUndo() {}
    
    func didTapLayers() {}
    
    func didTapRedo() {}
}
