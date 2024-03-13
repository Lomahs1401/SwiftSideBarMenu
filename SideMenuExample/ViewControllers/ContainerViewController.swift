//
//  ContainerViewController.swift
//  SideMenuExample
//
//  Created by Le Hoang Long on 12/03/2024.
//

import UIKit

class ContainerViewController: UIViewController {
    
    enum SideMenuState {
        case opened
        case closed
    }
    
    private var sideMenuState: SideMenuState = .closed
    private var overlayView: UIView?
    
    let menuVC = MenuViewController()
    let homeVC = HomeViewController()
    lazy var ratingVC =  RatingViewController()
    lazy var shareVC = ShareViewController()
    lazy var settingVC = SettingsViewController()
    var navVC: UINavigationController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        anotherAddChildVCs()
    }
    
    private func addChildVCs() {
        // Thêm child con theo thứ tự, menu trước, navHome sau -> Home nằm trên, MenuVC nằm dưới
        // Menu
        menuVC.delegate = self
        addChild(menuVC)
        view.addSubview(menuVC.view)
        menuVC.didMove(toParent: self)
        
        // Home
        homeVC.delegate = self
        let navVC = UINavigationController(rootViewController: homeVC)
        addChild(navVC)
        view.addSubview(navVC.view)
        navVC.didMove(toParent: self)
        self.navVC = navVC
    }
    
    private func anotherAddChildVCs() {
        // Home
        homeVC.delegate = self
        let navVC = UINavigationController(rootViewController: homeVC)
        addChild(navVC)
        view.insertSubview(navVC.view, aboveSubview: menuVC.view) // Thêm navVC lên trên menuVC
        navVC.didMove(toParent: self)
        self.navVC = navVC
        
        // Menu
        menuVC.delegate = self
        addChild(menuVC)
        view.insertSubview(menuVC.view, at: 0) // Thêm menuVC vào dưới cùng
        menuVC.didMove(toParent: self)
    }
    
    private func addOverlay(from menuSidebarOpenWidth: CGFloat) {
        if overlayView == nil {
            overlayView = UIView(frame: CGRect(x: menuSidebarOpenWidth, y: 0, width: view.bounds.width - menuSidebarOpenWidth, height: view.bounds.height))
            overlayView?.backgroundColor = UIColor.black.withAlphaComponent(0)
            
            let overlayTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleOverlayTap))
            overlayView?.addGestureRecognizer(overlayTapGestureRecognizer)
            
            view.addSubview(overlayView!)
        }
    }
    
    private func removeOverlay() {
        if let overlay = overlayView {
            overlay.removeFromSuperview()
            overlayView = nil
        }
    }
    
    @objc func handleOverlayTap() {
        toggleMenu(completion: nil)
    }
}

extension ContainerViewController: HomeViewControllerDelegate {
    func didTapMenuButton() {
        toggleMenu(completion: nil)
    }
    
    func toggleMenu(completion: (() -> Void)?) {
        switch sideMenuState {
        case .closed:
            /*
             ・withDuration: the time that the animation will take, in seconds.
             ・delay: the amount of time before the animation starts, in seconds. If you want the animation to start immediately, you can set this value to 0.
             ・usingSpringWithDamping: the animation's vibration reduction factor. This value determines how much the animation vibrates during the bounce and helps reduce the object's vibration to a stable value. This value usually ranges from 0 to 1, with 0 being no reduction vibration and 1 being strong reduction vibration.
             ・initialSpringVelocity: the initial velocity of the animation when it starts bouncing. The larger the value, the faster the animation will start.
             ・options: This is the option for animation
             　・curveEaseInOut: the default option, making it easier to animate animations. The animation starts slowly, gradually speeds up, then gradually decelerates at the end.
             　・curveEaseIn: animation starts slow and gradually speeds up.
             　・curveEaseOut: animation starts fast and slows down when it ends.
             　・curveLinear: animation happens at a steady speed and there are no changes in speed.
             　・repeat: repeat animation infinitely.
             　・autoreverse: after the animation ends, it will automatically reverse.
             ・animations: the closure that contains the operations you want to perform in the animation
             ・completion: the closure that will be called when the animation completes. You can use this closure to perform additional operations after the animation ends, like updating data or calling other functions.
             */
            
            // open menu
            let menuSidebarOpenWidth: CGFloat = (self.navVC?.view.frame.width)! - 76
            addOverlay(from: menuSidebarOpenWidth)
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: .curveEaseInOut) {
                self.navVC?.view.frame.origin.x = menuSidebarOpenWidth
                self.overlayView?.backgroundColor = UIColor.black.withAlphaComponent(0.5)
            } completion: { [weak self] done in
                if done {
                    self?.sideMenuState = .opened
                    
                }
            }
        case .opened:
            // close menu
            removeOverlay()
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: .curveEaseInOut) {
                self.navVC?.view.frame.origin.x = 0
            } completion: { [weak self] done in
                if done {
                    self?.sideMenuState = .closed
                    DispatchQueue.main.async {
                        completion?()
                    }
                }
            }
        }
    }
}

extension ContainerViewController: MenuViewControllerDelegate {
    func didSelect(menuItem: MenuViewController.MenuOptions) {
        //        toggleMenu(completion: nil)
        //        switch menuItem {
        //        case .home:
        //            resetToHome()
        //        case .info:
        //            let infoVC = InfoViewController()
        //            present(UINavigationController(rootViewController: infoVC), animated: true, completion: nil)
        //        case .appRating:
        //            // Add rating child
        //            addRating()
        //            break
        //        case .shareApp:
        //            break
        //        case .settings:
        //            break
        //        }
        
        toggleMenu { [weak self] in
            switch menuItem {
            case .home:
                self?.resetToHome()
            case .info:
                let infoVC = InfoViewController()
                self?.present(UINavigationController(rootViewController: infoVC), animated: true, completion: nil)
            case .appRating:
                // Add rating child
                self?.showRating()
                break
            case .shareApp:
                self?.showShare()
                break
            case .settings:
                self?.showSettings()
                break
            }
        }
    }
    
    func resetToHome() {
        if let currentChild = homeVC.children.first {
            currentChild.view.removeFromSuperview()
            currentChild.removeFromParent()
        }
        
        homeVC.title = "Home"
    }
    
    func showRating() {
        let ratingVC = self.ratingVC
        replaceCurrentChild(with: ratingVC)
        homeVC.title = ratingVC.title
    }
    
    func showShare() {
        let shareVC = self.shareVC
        replaceCurrentChild(with: shareVC)
        homeVC.title = shareVC.title
    }
    
    func showSettings() {
        let settingVC = self.settingVC
        replaceCurrentChild(with: settingVC)
        homeVC.title = settingVC.title
    }
    
    private func replaceCurrentChild(with newChild: UIViewController) {
        if let currentChild = homeVC.children.first {
            currentChild.view.removeFromSuperview()
            currentChild.removeFromParent()
        }
        homeVC.addChild(newChild)
        homeVC.view.addSubview(newChild.view)
        newChild.view.frame = view.frame
        newChild.didMove(toParent: homeVC)
    }
}
