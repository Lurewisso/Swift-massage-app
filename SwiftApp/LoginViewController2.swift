
import UIKit
import Foundation
import PostgresClientKit




class LoginViewController2: UIViewController {
    
    
    let segmentedControl: UISegmentedControl = {
        let control = UISegmentedControl(items: ["Вход", "Регистрация"])
        control.selectedSegmentIndex = 0
        control.addTarget(self, action: #selector(segmentChanged), for: .valueChanged)
        
        return control
    }()
    
    let emailTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Email"
        textField.borderStyle = .roundedRect
        textField.keyboardType = .emailAddress
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        return textField
    }()
    
    
    let nameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Имя"
        textField.borderStyle = .roundedRect
        textField.keyboardType = .emailAddress
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        return textField
    }()
    
    let surnameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Фамилия"
        textField.borderStyle = .roundedRect
        textField.keyboardType = .emailAddress
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        return textField
    }()
    
    
    let phoneTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Номер телефона"
        textField.borderStyle = .roundedRect
        textField.keyboardType = .emailAddress
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        return textField
    }()
    
    
    
    
    
    
    let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Пароль"
        textField.isSecureTextEntry = true
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    let confirmPasswordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Подтвердите пароль"
        textField.isSecureTextEntry = true
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    let actionButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Войти", for: .normal)
        button.addTarget(self, action: #selector(actionButtonTapped), for: .touchUpInside)
        button.layer.cornerRadius = 5
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.5
        button.layer.shadowOffset = CGSize(width: 5, height: 5)
        button.layer.shadowRadius = 5
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    let actionButtonEntering: UIButton = {
        let button2 = UIButton(type: .system)
        button2.setTitle("Войти", for: .normal)
        button2.addTarget(self, action: #selector(actionButtonTappedEnter), for: .touchUpInside)
        button2.layer.cornerRadius = 10
        button2.layer.shadowColor = UIColor.black.cgColor
        button2.layer.shadowOpacity = 0.5
        button2.layer.shadowOffset = CGSize(width: 5, height: 5)
        button2.layer.shadowRadius = 5
        button2.translatesAutoresizingMaskIntoConstraints = false
        button2.backgroundColor = .systemBlue
        button2.setTitleColor(.white, for: .normal)
        return button2
    }()
    
    // MARK:  Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        let isDarkMode = UserDefaults.standard.bool(forKey: "isDarkMode")
        updateAppBackground(isDarkMode: isDarkMode)
    }
    
    // MARK:  Setup UI
    
    func setupViews() {
        view.backgroundColor = .white
        
        view.addSubview(segmentedControl)
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        view.addSubview(confirmPasswordTextField)
        view.addSubview(actionButton)
        
        view.addSubview(nameTextField)
        view.addSubview(surnameTextField)
        view.addSubview(phoneTextField)
        view.addSubview(actionButtonEntering)
        
        
        
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        confirmPasswordTextField.translatesAutoresizingMaskIntoConstraints = false
        actionButton.translatesAutoresizingMaskIntoConstraints = false
        
        nameTextField.translatesAutoresizingMaskIntoConstraints = false
        surnameTextField.translatesAutoresizingMaskIntoConstraints = false
        phoneTextField.translatesAutoresizingMaskIntoConstraints = false
        actionButtonEntering.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            segmentedControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            segmentedControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            emailTextField.topAnchor.constraint(equalTo: phoneTextField.bottomAnchor, constant: 20),
            emailTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            emailTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 20),
            passwordTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            passwordTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            confirmPasswordTextField.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 20),
            confirmPasswordTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            confirmPasswordTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            nameTextField.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 20),
            nameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            nameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            surnameTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 20),
            surnameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            surnameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            phoneTextField.topAnchor.constraint(equalTo: surnameTextField.bottomAnchor, constant: 20),
            phoneTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            phoneTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            actionButton.topAnchor.constraint(equalTo: confirmPasswordTextField.bottomAnchor, constant: 20),
            actionButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            actionButton.widthAnchor.constraint(equalToConstant: 170),
            actionButton.heightAnchor.constraint(equalToConstant: 30),
            
            actionButtonEntering.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 20),
            actionButtonEntering.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            actionButtonEntering.widthAnchor.constraint(equalToConstant: 170),
            actionButtonEntering.heightAnchor.constraint(equalToConstant: 30),
        ])
        
        updateUIForSegment()
    }
    
    
    
    @objc func segmentChanged() {
        updateUIForSegment()
    }
    
    func updateUIForSegment() {
        if segmentedControl.selectedSegmentIndex == 0 {
            // Вход
            confirmPasswordTextField.isHidden = true
            confirmPasswordTextField.isHidden = true
            nameTextField.isHidden = true
            surnameTextField.isHidden = true
            phoneTextField.isHidden = true
            actionButton.isHidden = true
            actionButtonEntering.isHidden = false
            actionButtonEntering.setTitle("Войти в аккаунт", for: .normal)
        } else {
            // Регистрация
            confirmPasswordTextField.isHidden = false
            nameTextField.isHidden = false
            surnameTextField.isHidden = false
            phoneTextField.isHidden = false
            actionButtonEntering.isHidden = true
            actionButton.isHidden = false
            actionButton.setTitle("Зарегистрироваться", for: .normal)
        }
    }
    
    // MARK:  Actions
    
    @objc func actionButtonTappedEnter() {
        
        let alert = UIAlertController(title: "Типа успех", message: "Вы типа зашли)))", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "ОК", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
//        let mail = emailTextField.text ?? ""
//        let passwords = passwordTextField.text ?? ""
//        let confirmPassword = confirmPasswordTextField.text ?? ""
//        let name = nameTextField.text ?? ""
//        let surname = surnameTextField.text ?? ""
//        let phone = phoneTextField.text ?? ""
        
//        sendDataToServer(name: name, surname: surname, phone: phone, mail: mail, passwords: passwords)
    }
    
    
    
    
    @objc func actionButtonTapped() {
        let mail = emailTextField.text ?? ""
        let passwords = passwordTextField.text ?? ""
        let confirmPassword = confirmPasswordTextField.text ?? ""
        let name = nameTextField.text ?? ""
        let surname = surnameTextField.text ?? ""
        let phone = phoneTextField.text ?? ""
        
        sendDataToServer(name: name, surname: surname, phone: phone, mail: mail, passwords: passwords)
    }
    
    func updateAppBackground(isDarkMode: Bool) {
        view.backgroundColor = isDarkMode ? .black : .white
        
        
        
    }
    
    func sendDataToServer(name: String, surname: String, phone: String, mail: String, passwords: String) {
        DispatchQueue.global(qos: .background).async {
            do {
                var configuration = PostgresClientKit.ConnectionConfiguration()
                //                configuration.host = "127.0.0.1"
                configuration.host = "localhost"
                configuration.database = "postgres"
                configuration.user = "postgres"
                configuration.ssl = false
                configuration.port = 5432
                configuration.credential = .scramSHA256(password: "postgres")
                
                let connection = try PostgresClientKit.Connection(configuration: configuration)
                defer { connection.close() }
                
                let text = "INSERT INTO main_client_base (name, surname, phone, mail, passwords) VALUES ($1, $2, $3, $4, $5);"
                let statement = try connection.prepareStatement(text: text)
                defer { statement.close() }
                
                try statement.execute(parameterValues: [name, surname, phone, mail, passwords])
                
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "Успех", message: "Вы зарегистрированы", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "ОК", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            } catch {
                print("Ошибка подключения или выполнения запроса: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "Внимание!", message: "Ошибка ввода данных", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "ОК", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
    }
    
    
    
    
    
    
    // MARK:  Authentication Logic
    
    func login(mail: String, passwords: String) {
        
        
        DispatchQueue.global(qos: .background).async {
            do {
                var configuration = PostgresClientKit.ConnectionConfiguration()
                configuration.host = "localhost"
                configuration.database = "postgres"
                configuration.user = "postgres"
                configuration.ssl = false
                configuration.port = 5432
                configuration.credential = .scramSHA256(password: "postgres")
                
                let connection = try PostgresClientKit.Connection(configuration: configuration)
                defer { connection.close() }
                
                let text = "SELECT name FROM main_client_base WHERE mail = $1 AND passwords = $2;"
                //                    let text = "SELECT name FROM main_client_base WHERE mail = $1 AND passwords = $2;"
                
                let statement = try connection.prepareStatement(text: text)
                defer { statement.close() }
                
                let cursor = try statement.execute(parameterValues: [mail, passwords])
                
                DispatchQueue.main.async {
                    guard let rowCount = cursor.rowCount, rowCount > 0 else {
                      
                        let alert = UIAlertController(title: "Ошибка!", message: "Неверная почта или пароль", preferredStyle: .alert)
                        return
                    }
                    
                    let myProfileView = MyProfileView()
                    
                    guard let navigationController = self.navigationController else {
                        print("Navigation controller is nil")
     
                        let alert = UIAlertController(title: "Ошибка!", message: "Невозможно перейти к профилю", preferredStyle: .alert)
                        return
                    }
                    navigationController.pushViewController(myProfileView, animated: true)
                }
            } catch {
                print("Ошибка подключения или выполнения запроса: \(error.localizedDescription)")
                DispatchQueue.main.async {
                
                    let alert = UIAlertController(title: "Внимание!", message: "Ошибка ввода данных", preferredStyle: .alert)
                    
                }
            }
            
        }
        
        func register(email: String, password: String) {
            
            print("Регистрация с email: \(email) и паролем: \(password)")
            
            if email.isEmpty || password.isEmpty {
                showAlert(title: "Ошибка", message: "Пожалуйста, заполните все поля")
            } else {
                showAlert(title: "Успешно", message: "Регистрация прошла успешно")
            }
        }
        
        // MARK:  Helper Methods
        
        func showAlert(title: String, message: String) {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }
}
