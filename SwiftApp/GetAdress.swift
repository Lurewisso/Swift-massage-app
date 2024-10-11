
import UIKit
import Foundation

class GetAdress: UIViewController {
    
    let backgroundAdressFormImageView = UIImageView()
    let button = UIButton()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
//        setupUI()
        let isDarkMode = UserDefaults.standard.bool(forKey: "isDarkMode")
                updateAppBackground(isDarkMode: isDarkMode)
        
//        view.backgroundColor = .blue
        
//        backgroundAdressFormImageView.image = UIImage(named: "wallpaperBlack")
        backgroundAdressFormImageView.contentMode = .scaleAspectFill
        backgroundAdressFormImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(backgroundAdressFormImageView)
        
//        let button = UIButton()
        button.setTitle("Перейти к карте", for: .normal)
        button.setTitle("Loading", for: .selected)
        button.setTitleColor(.white, for: .normal)
//        button.backgroundColor = .red
        button.layer.cornerRadius = 10
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.5
        button.layer.shadowOffset = CGSize(width: 5, height: 5)
        button.layer.shadowRadius = 5
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.addTarget(self, action: #selector(openMap), for: .touchUpInside)
        
        view.addSubview(button)

        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            button.widthAnchor.constraint(equalToConstant: 200),
            button.heightAnchor.constraint(equalToConstant: 50),
            
            backgroundAdressFormImageView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundAdressFormImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundAdressFormImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundAdressFormImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    @objc func openMap() {
        if let url = URL(string: "https://yandex.ru/maps/-/CDbyUPjf") {
            UIApplication.shared.open(url)
        }
    }
    func updateAppBackground(isDarkMode: Bool) {
            view.backgroundColor = isDarkMode ? .black : .systemGray2
            button.backgroundColor = isDarkMode ? .systemRed : .systemBlue
            
        
            
        }
}
