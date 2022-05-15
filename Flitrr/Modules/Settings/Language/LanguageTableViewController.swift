//
//  LanguageTableViewController.swift
//  Flitrr
//
//  Created by Vladyslav Baranov on 22.04.2022.
//

import UIKit

final class LanguageTableViewController: UITableViewController {
    
    struct SettingsItem {
        var lang: String
        var isSelected = false
        var id = "en"
    }
    
    var searchKey = ""
    var searchResult: [SettingsItem] = []
    
    var languages: [SettingsItem] = [
        .init(lang: "English", id: "en"),
        .init(lang: "Española", id: "es"),
        .init(lang: "中国人", id: "zh-Hans"),
        .init(lang: "日本", id: "ja"),
        .init(lang: "Français", id: "fr"),
        .init(lang: "Deutsch", id: "de"),
        .init(lang: "Русский", id: "ru"),
        .init(lang: "Português", id: "pt-PT"),
        .init(lang: "Italiano", id: "it"),
        .init(lang: "한국인", id: "ko")
    ]

    let searchController = UISearchController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableHeaderView = UIView()
        navigationItem.title = "Language"
        navigationItem.searchController = searchController
        searchController.searchBar.delegate = self
        navigationItem.hidesSearchBarWhenScrolling = false
        tableView.register(SettingsTableCell.self, forCellReuseIdentifier: "id")
        tableView.separatorInset = .init(top: 0, left: 30, bottom: 0, right: 30)

        for (i, lang) in languages.enumerated() {
            if lang.id == LocalizationManager.shared.locale {
                languages[i].isSelected = true
            }
        }
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let lang = getLanguage(for: indexPath)
        for i in 0..<languages.count {
            self.languages[i].isSelected = lang.lang == self.languages[i].lang
        }
        LocalizationManager.shared.locale = lang.id
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "id", for: indexPath) as! SettingsTableCell
        let lang = getLanguage(for: indexPath)
        cell.selectionStyle = .none
        cell.textLabel?.text = lang.lang
        cell.customAccessoryType = lang.isSelected ? .checkmark : .none
        cell.backgroundColor = .clear
        return cell
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        70
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        numberOfRows()
    }
}

extension LanguageTableViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchKey = searchText.lowercased()
        searchWithKey()
        tableView.reloadData()
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchKey = ""
        tableView.reloadData()
    }
    
    func searchWithKey() {
        searchResult = languages.filter({ item in
            item.lang.lowercased().contains(searchKey)
        })
    }
    
    func getLanguage(for indexPath: IndexPath) -> SettingsItem {
        if searchKey.isEmpty {
            return languages[indexPath.row]
        } else {
            return searchResult[indexPath.row]
        }
    }
    func numberOfRows() -> Int {
        if searchKey.isEmpty {
            return languages.count
        } else {
            return searchResult.count
        }
    }
}
