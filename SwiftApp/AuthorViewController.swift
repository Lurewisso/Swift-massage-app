
import UIKit
import Foundation


class AuthorViewController: UIViewController {
    
    let backgroundAuthorFormImageView = UIImageView()
    let infoView = UIView()
    let infoLabel = UILabel()
    let closeButton = UIButton()
    let button = UIButton()
    let button2 = UIButton()
    let button3 = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        setupUI()
        let isDarkMode = UserDefaults.standard.bool(forKey: "isDarkMode")
                updateAppBackground(isDarkMode: isDarkMode)
        
//        backgroundAuthorFormImageView.image = UIImage(named: "wallpaperBlack")
        backgroundAuthorFormImageView.contentMode = .scaleAspectFill
        backgroundAuthorFormImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(backgroundAuthorFormImageView)
        
//        let button = UIButton()
//        let button2 = UIButton()
//        let button3 = UIButton()
        
        setupButton(button, title: "Авторский курс")
        setupButton(button2, title: "Курс Яблоко")
        setupButton(button3, title: "Курс Груша")
        
        button.addTarget(self, action: #selector(showCourses(_:)), for: .touchUpInside)
        button2.addTarget(self, action: #selector(showCourses(_:)), for: .touchUpInside)
        button3.addTarget(self, action: #selector(showCourses(_:)), for: .touchUpInside)
        
        view.addSubview(button)
        view.addSubview(button2)
        view.addSubview(button3)
        
        setupInfoView()
        
        NSLayoutConstraint.activate([
            backgroundAuthorFormImageView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundAuthorFormImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundAuthorFormImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundAuthorFormImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            button.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 260),
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.widthAnchor.constraint(equalToConstant: 200),
            button.heightAnchor.constraint(equalToConstant: 50),
            
            button2.topAnchor.constraint(equalTo: button.bottomAnchor, constant: 20),
            button2.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button2.widthAnchor.constraint(equalToConstant: 200),
            button2.heightAnchor.constraint(equalToConstant: 50),
            
            button3.topAnchor.constraint(equalTo: button2.bottomAnchor, constant: 20),
            button3.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button3.widthAnchor.constraint(equalToConstant: 200),
            button3.heightAnchor.constraint(equalToConstant: 50),
            
            infoView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            infoView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            infoView.topAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func setupButton(_ button: UIButton, title: String) {
        button.setTitle(title, for: .normal)
        button.setTitle("Loading", for: .selected)
        button.setTitleColor(.white, for: .normal)
//        button.backgroundColor = .red
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
//        closeButton.backgroundColor = .red
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
            closeButton.widthAnchor.constraint(equalToConstant: 200),
            closeButton.heightAnchor.constraint(equalToConstant: 50),
            
            infoView.bottomAnchor.constraint(equalTo: closeButton.bottomAnchor, constant: 20) // Dynamic height constraint
        ])
    }
    func updateAppBackground(isDarkMode: Bool) {
            view.backgroundColor = isDarkMode ? .black : .systemGray2
            button.backgroundColor = isDarkMode ? .systemRed : .systemBlue
            button2.backgroundColor = isDarkMode ? .systemRed : .systemBlue
            button3.backgroundColor = isDarkMode ? .systemRed : .systemBlue
            closeButton.backgroundColor = isDarkMode ? .systemRed : .systemBlue
        }
    
    @objc func showCourses(_ sender: UIButton) {
        var infoText = ""
        switch sender.currentTitle {
        case "Авторский курс":
            infoText = """
            Авторский курс состоит из 10 сеансов.
            ▪️В один сеанс входит от 2-х до 4-х техник, подобранных индивидуально для каждого клиента.
            ▪️Длительность сеанса варьируется от 40 до 120 минут.
            ▪️Регулярность сеансов: 1 - 2  сеанса в неделю.
            ▪️Регулярность сеансов: возможнен 1 сеанс в две недели (мастер оценивает реакцию организма).
            ▪️При менструации - отмена и перенос сеанса.
            ▪️При заболеваниях (либо плохом самочувствии) - отмена и перенос сеанса.
            ▪️Стоимость курса можно разделить на три платежа.
            ▪️Стоимость курса - 30.000₽.
            ▪️Стоимость сеанса - 3.000₽.
            """
        case "Курс Яблоко":
            infoText = """
            🍎Курс Яблоко состоит из 10 сеансов.
            ▪️В один сеанс входит от 2-х до 5-ти техник, подобранных индивидуально для каждого клиента.
            ▪️Длительность сеанса варьируется от 60 до 120 минут.
            ▪️Зоны работы: Живот, бока, спина, холка.
            ▪️Регулярность сеансов: 1 - 2  сеанса в неделю.
            ▪️Регулярность сеансов: возможнен 1 сеанс в две недели (мастер оценивает реакцию организма).
            ▪️При менструации - отмена и перенос сеанса.
            ▪️При заболеваниях (либо плохом самочувствии) - отмена и перенос сеанса.
            ▪️Стоимость курса можно разделить на два платежа, на первом сеансе - первый платёж, на шестом сеансе - второй платеж.
            ▪️Стоимость курса - 25.000₽.
            ▪️Стоимость сеанса - 2.500₽.
            """
        case "Курс Груша":
            infoText = """
            🍐Курс Груша состоит из 10 сеансов.
            ▪️В один сеанс входит от 2-х до 5-ти техник, подобранных индивидуально для каждого клиента.
            ▪️Длительность сеанса варьируется от 40 до 120 минут.
            ▪️Зоны работы: Ягодицы, все зоны бёдер.
            ▪️Регулярность сеансов: 1 - 2  сеанса в неделю.
            ▪️Регулярность сеансов: возможнен 1 сеанс в две недели (мастер оценивает реакцию организма).
            ▪️При менструации - отмена и перенос сеанса.
            ▪️При заболеваниях (либо плохом самочувствии) - отмена и перенос сеанса.
            ▪️Стоимость курса можно разделить на два платежа, на первом сеансе - первый платёж, на шестом сеансе - второй платеж.
            ▪️Стоимость курса - 25.000₽.
            ▪️Стоимость сеанса - 2.500₽.
            """
        default:
            infoText = "Информация о курсе."
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
