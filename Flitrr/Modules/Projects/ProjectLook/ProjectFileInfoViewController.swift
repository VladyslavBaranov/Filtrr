//
//  ProjectFileInfoViewController.swift
//  Flitrr
//
//  Created by Vladyslav Baranov on 21.05.2022.
//

import UIKit

final class ProjectFileInfoViewController: UITableViewController {
    
    var imageSize: CGSize = .zero
    
    struct Model {
        var title: String
        var value: String
    }
    
    private var models: [Model] = []
    
    var project: Project!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let creationDate = project.created {
            models.append(.init(title: LocalizationManager.shared.localizedString(for: .fileInfoCreated), value: creationDate.description))
        }
        if let component = project.url?.lastPathComponent {
            models.append(.init(title: LocalizationManager.shared.localizedString(for: .fileInfoName), value: component))
        }
        if let `extension` = project.url?.pathExtension {
            models.append(.init(title: LocalizationManager.shared.localizedString(for: .fileInfoExt), value: `extension`.uppercased()))
        }
        models.append(.init(title: LocalizationManager.shared.localizedString(for: .fileInfoRes), value: "\(Int(imageSize.height)) x \(Int(imageSize.width))"))
        
        if let count = project.getPNGData()?.count {
            let formatter = ByteCountFormatter.string(
                fromByteCount: Int64(count),
                countStyle: .file
            )
            models.append(.init(title: LocalizationManager.shared.localizedString(for: .fileInfoSize), value: "\(formatter)"))
        }
        
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        models.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: "id")
        cell.textLabel?.text = models[indexPath.row].title
        cell.detailTextLabel?.text = models[indexPath.row].value
        return cell
    }
}
