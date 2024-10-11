
import UIKit
import Foundation
import PostgresClientKit

class RegistrViewController: UIViewController{
    let nameTextField = UITextField()
    let surnameTextField = UITextField()
    let phoneTextField = UITextField()
    let mailTextField = UITextField()
    let passwordTextField = UITextField()
    let submitButton = UIButton()
    let backgroundInputFormImageView = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //        setupUI()
        let isDarkMode = UserDefaults.standard.bool(forKey: "isDarkMode")
        updateAppBackground(isDarkMode: isDarkMode)
        
        
        //        backgroundInputFormImageView.image = UIImage(named: "wallpaperBlack")
        backgroundInputFormImageView.contentMode = .scaleAspectFill
        backgroundInputFormImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(backgroundInputFormImageView)
        
        setupTextField(nameTextField, placeholder: "Имя:", topAnchor: view.safeAreaLayoutGuide.topAnchor, constant: 20)
        setupTextField(surnameTextField, placeholder: "Фамилия:", topAnchor: nameTextField.bottomAnchor, constant: 30)
        setupTextField(phoneTextField, placeholder: "Номер телефона:", topAnchor: surnameTextField.bottomAnchor, constant: 30)
        setupTextField(mailTextField, placeholder: "Почта:", topAnchor: phoneTextField.bottomAnchor, constant: 30)
        setupTextField(passwordTextField, placeholder: "Пароль: ", topAnchor: mailTextField.bottomAnchor, constant: 30)
        
        submitButton.setTitle("Зарегистрироваться", for: .normal)
        submitButton.setTitleColor(.white, for: .normal)
//        submitButton.backgroundColor = .blue
        submitButton.layer.cornerRadius = 10
        submitButton.layer.shadowColor = UIColor.black.cgColor
        submitButton.layer.shadowOpacity = 0.5
        submitButton.layer.shadowOffset = CGSize(width: 5, height: 5)
        submitButton.layer.shadowRadius = 5
        submitButton.translatesAutoresizingMaskIntoConstraints = false
        submitButton.addTarget(self, action: #selector(submitData), for: .touchUpInside)
        view.addSubview(submitButton)
        
        NSLayoutConstraint.activate([
            submitButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 20),
            submitButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            submitButton.widthAnchor.constraint(equalToConstant: 200),
            submitButton.heightAnchor.constraint(equalToConstant: 50),
            
            backgroundInputFormImageView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundInputFormImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundInputFormImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundInputFormImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func setupTextField(_ textField: UITextField, placeholder: String, topAnchor: NSLayoutYAxisAnchor, constant: CGFloat) {
        textField.placeholder = placeholder
        textField.borderStyle = .roundedRect
        textField.backgroundColor = .white
        textField.layer.cornerRadius = 10
        textField.layer.shadowColor = UIColor.black.cgColor
        textField.layer.shadowOpacity = 0.5
        textField.layer.shadowOffset = CGSize(width: 5, height: 5)
        textField.layer.shadowRadius = 5
        textField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(textField)
        
        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: topAnchor, constant: constant),
            textField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            textField.widthAnchor.constraint(equalToConstant: 300),
            textField.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    func updateAppBackground(isDarkMode: Bool) {
        view.backgroundColor = isDarkMode ? .black : .systemGray2
        submitButton.backgroundColor = isDarkMode ? .red : .blue
    }
    
    @objc func submitData() {
        let name = nameTextField.text ?? ""
        let surname = surnameTextField.text ?? ""
        let phone = phoneTextField.text ?? ""
        let mail = mailTextField.text ?? ""
        let passwords = passwordTextField.text ?? ""
        
        sendDataToServer(name: name, surname: surname, phone: phone, mail: mail, passwords: passwords)
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
}
