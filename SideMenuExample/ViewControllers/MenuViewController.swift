//
//  MenuViewController.swift
//  SideMenuExample
//
//  Created by Le Hoang Long on 12/03/2024.
//

import UIKit

protocol MenuViewControllerDelegate: AnyObject {
    func didSelect(menuItem: MenuViewController.MenuOptions)
}

class MenuViewController: UIViewController {
    
    weak var delegate: MenuViewControllerDelegate?
    
    enum MenuOptions: String, CaseIterable {
        case home = "Home"
        case info = "Information"
        case appRating = "App Rating"
        case shareApp = "Share App"
        case settings = "Settings"
        
        var imageName: String {
            switch self {
            case .home:
                return "house"
            case .info:
                return "airplane"
            case .appRating:
                return "star"
            case .shareApp:
                return "message"
            case .settings:
                return "gear"
            }
        }
    }
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.backgroundColor = .clear
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(self.tableView)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        setBackgroundForCurrentTraitCollection()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.tableView.frame = CGRect(x: 0, y: 0, width: view.bounds.size.width, height: view.bounds.size.height)
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        setBackgroundForCurrentTraitCollection()
    }
    
    private func setBackgroundForCurrentTraitCollection() {
        let userInterfaceStyle = traitCollection.userInterfaceStyle
        view.backgroundColor = backgroundColorForUserInterfaceStyle(userInterfaceStyle)
        tableView.reloadData() // to update background of table
    }
    
    func textColorForUserInterfaceStyle(_ userInterfaceStyle: UIUserInterfaceStyle) -> UIColor {
        return userInterfaceStyle == .dark ? .white : .black
    }

    func backgroundColorForUserInterfaceStyle(_ userInterfaceStyle: UIUserInterfaceStyle) -> UIColor {
        if userInterfaceStyle == .dark {
            return UIColor(red: 33/255.0, green: 33/255.0, blue: 33/255.0, alpha: 1)
        } else {
            return UIColor.white
        }
    }
}

extension MenuViewController: UITableViewDelegate {
    
}

extension MenuViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MenuOptions.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = MenuOptions.allCases[indexPath.row].rawValue
        cell.textLabel?.textColor = textColorForUserInterfaceStyle(traitCollection.userInterfaceStyle)
        
        cell.imageView?.image = UIImage(systemName: MenuOptions.allCases[indexPath.row].imageName)
        cell.imageView?.tintColor = textColorForUserInterfaceStyle(traitCollection.userInterfaceStyle)

        cell.backgroundColor = backgroundColorForUserInterfaceStyle(traitCollection.userInterfaceStyle)
        cell.contentView.backgroundColor = backgroundColorForUserInterfaceStyle(traitCollection.userInterfaceStyle)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let item = MenuOptions.allCases[indexPath.row]
        delegate?.didSelect(menuItem: item)
    }
}
