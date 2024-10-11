

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let scheduleViewController = RaspisanieViewController()
        addChild(scheduleViewController)
        view.addSubview(scheduleViewController.view)
        
        scheduleViewController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scheduleViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scheduleViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scheduleViewController.view.topAnchor.constraint(equalTo: view.topAnchor),
            scheduleViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        scheduleViewController.didMove(toParent: self)
    }
}

