
import UIKit
import Foundation
import PostgresClientKit

class InputFormViewController: UIViewController {
    let nameTextField = UITextField()
    let phoneTextField = UITextField()
    let reasonTextField = UITextField()
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

        setupTextField(nameTextField, placeholder: "Имя: ", topAnchor: view.safeAreaLayoutGuide.topAnchor, constant: 100)
        setupTextField(phoneTextField, placeholder: "Номер телефона: ", topAnchor: nameTextField.bottomAnchor, constant: 20)
        setupTextField(reasonTextField, placeholder: "Причина обращения: ", topAnchor: phoneTextField.bottomAnchor, constant: 20)

        submitButton.setTitle("Отправить", for: .normal)
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
            submitButton.topAnchor.constraint(equalTo: reasonTextField.bottomAnchor, constant: 20),
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
        textField.textColor = .black
        textField.layer.shadowOffset = CGSize(width: 5, height: 5)
        textField.layer.shadowRadius = 5
        textField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(textField)
        
        //  цвет плейсхолдера
        textField.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray])
        
        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: topAnchor, constant: constant),
            textField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            textField.widthAnchor.constraint(equalToConstant: 300),
            textField.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    func updateAppBackground(isDarkMode: Bool) {
            view.backgroundColor = isDarkMode ? .black : .lightGray
            submitButton.backgroundColor = isDarkMode ? .systemRed : .systemBlue
       
        
            
        }

    @objc func submitData() {
        let name = nameTextField.text ?? ""
        let phone = phoneTextField.text ?? ""
        let reason = reasonTextField.text ?? ""

        sendDataToServer(name: name, phone: phone, reason: reason)
    }

    func sendDataToServer(name: String, phone: String, reason: String) {
        DispatchQueue.global(qos: .background).async {
            do {
                var configuration = PostgresClientKit.ConnectionConfiguration()
                configuration.host = "localhost"
                configuration.database = "postgres"
                configuration.user = "postgres"
                configuration.ssl = false
                configuration.credential = .scramSHA256(password: "postgres")

                let connection = try PostgresClientKit.Connection(configuration: configuration)
                defer { connection.close() }

                let text = "INSERT INTO appsclient (name, phone, reason) VALUES ($1, $2, $3);"
                let statement = try connection.prepareStatement(text: text)
                defer { statement.close() }

                try statement.execute(parameterValues: [name, phone, reason])
                
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "Успех", message: "Данные успешно отправлены", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "ОК", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            } catch {
                print("Ошибка подключения или выполнения запроса: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "Ошибка", message: "Не удалось отправить данные", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
    }

}
