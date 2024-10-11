class SettingViewController: UIViewController {
    
    let backgroundSettingsFormImageView = UIImageView()
    let infoView = UIView()
    let infoLabel = UILabel()
    let closeButton = UIButton()
    let themeSwitch = UISwitch()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let isDarkMode = UserDefaults.standard.bool(forKey: "isDarkMode")
        
       
        updateAppBackground(isDarkMode: isDarkMode)
        
        themeSwitch.isOn = isDarkMode
        
        backgroundSettingsFormImageView.contentMode = .scaleAspectFill
        backgroundSettingsFormImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(backgroundSettingsFormImageView)
        
        let button = UIButton()
        let button2 = UIButton()
        let button3 = UIButton()
        
        setupButton(button, title: " Light  /  Dark ")
        setupButton(button2, title: "Изменить шрифт")
        setupButton(button3, title: "Внешний вид")
        
        button.addTarget(self, action: #selector(showCourses(_:)), for: .touchUpInside)
        button2.addTarget(self, action: #selector(showCourses(_:)), for: .touchUpInside)
        button3.addTarget(self, action: #selector(showCourses(_:)), for: .touchUpInside)
        
        view.addSubview(button)
        view.addSubview(button2)
        view.addSubview(button3)
        
        setupInfoView()
        
        themeSwitch.addTarget(self, action: #selector(toggleTheme), for: .valueChanged)
        themeSwitch.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(themeSwitch)
        
        NSLayoutConstraint.activate([
            backgroundSettingsFormImageView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundSettingsFormImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundSettingsFormImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundSettingsFormImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            button.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 240),
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.widthAnchor.constraint(equalToConstant: 200),
            button.heightAnchor.constraint(equalToConstant: 50),
            
            button2.topAnchor.constraint(equalTo: button.bottomAnchor, constant: 70),
            button2.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button2.widthAnchor.constraint(equalToConstant: 200),
            button2.heightAnchor.constraint(equalToConstant: 50),
            
            button3.topAnchor.constraint(equalTo: button2.bottomAnchor, constant: 20),
            button3.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button3.widthAnchor.constraint(equalToConstant: 200),
            button3.heightAnchor.constraint(equalToConstant: 50),
            
            themeSwitch.topAnchor.constraint(equalTo: button.bottomAnchor, constant: 20),
            themeSwitch.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            infoView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            infoView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            infoView.topAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func setupButton(_ button: UIButton, title: String) {
        button.setTitle(title, for: .normal)
        button.setTitle("Loading", for: .selected)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .white
        button.layer.cornerRadius = 10
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.5
        button.layer.shadowOffset = CGSize(width: 5, height: 5)
        button.layer.shadowRadius = 5
        button.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func setupInfoView() {
        infoView.backgroundColor = .white
        infoView.layer.cornerRadius = 10
        infoView.layer.shadowColor = UIColor.black.cgColor
        infoView.layer.shadowOpacity = 0.5
        infoView.layer.shadowOffset = CGSize(width: 5, height: 5)
        infoView.layer.shadowRadius = 5
        infoView.translatesAutoresizingMaskIntoConstraints = false
        infoView.isHidden = true
        
        infoLabel.text = ""
        infoLabel.textColor = .black
        infoLabel.numberOfLines = 0
        infoLabel.translatesAutoresizingMaskIntoConstraints = false
        
        infoView.addSubview(infoLabel)
        view.addSubview(infoView)
        
        closeButton.setTitle("Закрыть окно", for: .normal)
        closeButton.setTitleColor(.white, for: .normal)
        closeButton.backgroundColor = .red
        closeButton.layer.cornerRadius = 10
        closeButton.layer.shadowColor = UIColor.black.cgColor
        closeButton.layer.shadowOpacity = 0.5
        closeButton.layer.shadowOffset = CGSize(width: 6, height: 5)
        closeButton.layer.shadowRadius = 5
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.addTarget(self, action: #selector(closeInfoView), for: .touchUpInside)
        
        infoView.addSubview(closeButton)
        
        NSLayoutConstraint.activate([
            infoLabel.topAnchor.constraint(equalTo: infoView.topAnchor, constant: 20),
            infoLabel.leadingAnchor.constraint(equalTo: infoView.leadingAnchor, constant: 20),
            infoLabel.trailingAnchor.constraint(equalTo: infoView.trailingAnchor, constant: -20),
            
            closeButton.topAnchor.constraint(equalTo: infoLabel.bottomAnchor, constant: 20),
            closeButton.centerXAnchor.constraint(equalTo: infoView.centerXAnchor),
            closeButton.bottomAnchor.constraint(equalTo: infoView.bottomAnchor, constant: -20),
            
            infoView.bottomAnchor.constraint(equalTo: closeButton.bottomAnchor, constant: 20)
        ])
    }
    
    @objc func toggleTheme() {
        let isDarkMode = themeSwitch.isOn
       
        UserDefaults.standard.set(isDarkMode, forKey: "isDarkMode")
        
        
        updateAppBackground(isDarkMode: isDarkMode)
    }
    
    func updateAppBackground(isDarkMode: Bool) {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first else { return }
        
        window.backgroundColor = isDarkMode ? .black : .lightGray
        
       
        for viewController in window.rootViewController?.children ?? [] {
            viewController.view.backgroundColor = isDarkMode ? .black : .lightGray
        }
    }
    
    @objc func showCourses(_ sender: UIButton) {
        var infoText = ""
        switch sender.currentTitle {
        case "Light    Dark":
            infoText = ""
        case "Изменить шрифт":
            infoText = ""
        case "Внешний вид":
            infoText = ""
        default:
            infoText = ""
        }
        infoLabel.text = infoText
        showInfoView()
    }
    
    func showInfoView() {
        infoView.isHidden = false
        view.layoutIfNeeded()
        
        UIView.animate(withDuration: 0.3) {
            self.infoView.transform = CGAffineTransform(translationX: 0, y: -self.infoView.frame.height)
        }
    }
    
    @objc func closeInfoView() {
        UIView.animate(withDuration: 0.3, animations: {
            self.infoView.transform = .identity
        }) { _ in
            self.infoView.isHidden = true
        }
    }
}
