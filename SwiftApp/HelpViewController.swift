
import UIKit
import Foundation

class HelpViewController: UIViewController {
    let backgroundHelpFormImageView = UIImageView()
    let photo_donat = ["sber"]
    let button = UIButton()
    let button2 = UIButton()
    let button3 = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let isDarkMode = UserDefaults.standard.bool(forKey: "isDarkMode")
        updateAppBackground(isDarkMode: isDarkMode)
        
        backgroundHelpFormImageView.contentMode = .scaleAspectFill
        backgroundHelpFormImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(backgroundHelpFormImageView)
        
        setupButton(button, title: "Написать разработчику", action: #selector(openLinkTG))
        setupButton(button2, title: "Донат разработчику", action: #selector(openPhotoSber))
        setupButton(button3, title: "Ваши предложения", action: #selector(sendMail))
        
        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -90),
            button.widthAnchor.constraint(equalToConstant: 300),
            button.heightAnchor.constraint(equalToConstant: 50),
            
            button2.topAnchor.constraint(equalTo: button.bottomAnchor, constant: 30),
            button2.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button2.widthAnchor.constraint(equalToConstant: 300),
            button2.heightAnchor.constraint(equalToConstant: 50),
            
            button3.topAnchor.constraint(equalTo: button2.bottomAnchor, constant: 30),
            button3.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button3.widthAnchor.constraint(equalToConstant: 300),
            button3.heightAnchor.constraint(equalToConstant: 50),
            
            backgroundHelpFormImageView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundHelpFormImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundHelpFormImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundHelpFormImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }

    func setupButton(_ button: UIButton, title: String, action: Selector) {
        button.setTitle(title, for: .normal)
        button.setTitleColor(.white, for: .normal)
//        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 10
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.5
        button.layer.shadowOffset = CGSize(width: 5, height: 5)
        button.layer.shadowRadius = 5
        button.addTarget(self, action: action, for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(button)
    }

    @objc func openLinkTG() {
        if let url = URL(string: "https://t.me/lurewisso") {
            UIApplication.shared.open(url)
        }
    }
    
    func updateAppBackground(isDarkMode: Bool) {
        view.backgroundColor = isDarkMode ? .black : .systemGray2
        backgroundHelpFormImageView.image = isDarkMode ? UIImage(named: "darkBackground") : UIImage(named: "lightBackground")
        button.backgroundColor = isDarkMode ? .systemRed : .systemBlue
        button2.backgroundColor = isDarkMode ? .systemRed : .systemBlue
        button3.backgroundColor = isDarkMode ? .systemRed : .systemBlue
    }
    
    @objc func openPhotoSber() {
        let photoViewController = UIViewController()
        let imageView = UIImageView(image: UIImage(named: photo_donat[0]))
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        let closeButton = UIButton()
        closeButton.setTitle("Закрыть", for: .normal)
        closeButton.setTitleColor(.white, for: .normal)
        closeButton.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        closeButton.layer.cornerRadius = 10
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.addTarget(self, action: #selector(closePhotoView), for: .touchUpInside)
        
        photoViewController.view.addSubview(imageView)
        photoViewController.view.addSubview(closeButton)
        
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: photoViewController.view.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: photoViewController.view.centerYAnchor),
            imageView.widthAnchor.constraint(equalTo: photoViewController.view.widthAnchor, multiplier: 0.9),
            imageView.heightAnchor.constraint(equalTo: photoViewController.view.heightAnchor, multiplier: 0.9),
            
            closeButton.bottomAnchor.constraint(equalTo: photoViewController.view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            closeButton.centerXAnchor.constraint(equalTo: photoViewController.view.centerXAnchor),
            closeButton.widthAnchor.constraint(equalToConstant: 100),
            closeButton.heightAnchor.constraint(equalToConstant: 50),
        ])
        
        present(photoViewController, animated: true, completion: nil)
    }
    
    @objc func closePhotoView() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func sendMail() {
        if let url = URL(string: "https://vk.com/lurewisso") {
            UIApplication.shared.open(url)
        }
    }
}

