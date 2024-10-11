
import UIKit
import Foundation
import PostgresClientKit

class EnterViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let loginVC = LoginViewController()
        addChild(loginVC)
        view.addSubview(loginVC.view)
        loginVC.didMove(toParent: self)
    }

    class LoginViewController: UIViewController {
        let mailTextField = UITextField()
        let passwordTextField = UITextField()
        let submitButton = UIButton()
        let registrButton = UIButton()
        let backgroundInputFormImageView = UIImageView()

        override func viewDidLoad() {
            super.viewDidLoad()

            let isDarkMode = UserDefaults.standard.bool(forKey: "isDarkMode")
            updateAppBackground(isDarkMode: isDarkMode)

            setupBackgroundImageView()
            setupTextField(mailTextField, placeholder: "Почта:", topAnchor: view.safeAreaLayoutGuide.topAnchor, constant: 100)
            setupTextField(passwordTextField, placeholder: "Пароль:", topAnchor: mailTextField.bottomAnchor, constant: 30)
            setupSubmitButton()
//            setupRegistrButton()
        }

        private func setupBackgroundImageView() {
            backgroundInputFormImageView.contentMode = .scaleAspectFill
            backgroundInputFormImageView.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(backgroundInputFormImageView)

            NSLayoutConstraint.activate([
                backgroundInputFormImageView.topAnchor.constraint(equalTo: view.topAnchor),
                backgroundInputFormImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                backgroundInputFormImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                backgroundInputFormImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
        }

        private func setupTextField(_ textField: UITextField, placeholder: String, topAnchor: NSLayoutYAxisAnchor, constant: CGFloat) {
            textField.placeholder = placeholder
            textField.borderStyle = .roundedRect
            textField.backgroundColor = .white
            textField.layer.cornerRadius = 10
//            textField.isSecureTextEntry = true
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

        private func setupRegistrButton() {
            registrButton.setTitle("Регистрация", for: .normal)
            registrButton.setTitleColor(.white, for: .normal)
            registrButton.layer.cornerRadius = 10
            registrButton.layer.shadowColor = UIColor.black.cgColor
            registrButton.layer.shadowOpacity = 0.5
            registrButton.layer.shadowOffset = CGSize(width: 5, height: 5)
            registrButton.layer.shadowRadius = 5
            registrButton.translatesAutoresizingMaskIntoConstraints = false
           
            registrButton.addTarget(self, action: #selector(registrForm1), for: .touchUpInside)
            view.addSubview(registrButton)

            NSLayoutConstraint.activate([
                registrButton.topAnchor.constraint(equalTo: submitButton.bottomAnchor, constant: 20),
                registrButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                registrButton.widthAnchor.constraint(equalToConstant: 200),
                registrButton.heightAnchor.constraint(equalToConstant: 50)
            ])
        }

        private func setupSubmitButton() {
            submitButton.setTitle("Войти", for: .normal)
            submitButton.setTitleColor(.white, for: .normal)
            submitButton.layer.cornerRadius = 10
            submitButton.layer.shadowColor = UIColor.black.cgColor
            submitButton.layer.shadowOpacity = 0.5
            submitButton.layer.shadowOffset = CGSize(width: 5, height: 5)
            submitButton.layer.shadowRadius = 5
            submitButton.translatesAutoresizingMaskIntoConstraints = false
            submitButton.addTarget(self, action: #selector(submitData), for: .touchUpInside)
            view.addSubview(submitButton)

            NSLayoutConstraint.activate([
                submitButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 40),
                submitButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                submitButton.widthAnchor.constraint(equalToConstant: 200),
                submitButton.heightAnchor.constraint(equalToConstant: 50)
            ])
        }
        
        private func updateAppBackground(isDarkMode: Bool) {
            view.backgroundColor = isDarkMode ? .black : .systemGray2
            submitButton.backgroundColor = isDarkMode ? .red : .blue
            registrButton.backgroundColor = isDarkMode ? .red : .blue
        }

        @objc private func submitData() {
            let mail = mailTextField.text ?? ""
            let passwords = passwordTextField.text ?? ""

            sendDataToServer(mail: mail, passwords: passwords)
        }
        
        @objc func registrForm1() {
            let registrVC = RegistrViewController()
           
            navigationController?.pushViewController(registrVC, animated: true)
            
        }

        private func sendDataToServer(mail: String, passwords: String) {
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
                            self.showAlert(title: "Ошибка", message: "Неверная почта или пароль ")
                            return
                        }

                        let myProfileView = MyProfileView()
                        
                        guard let navigationController = self.navigationController else {
                            print("Navigation controller is nil")
                            self.showAlert(title: "Ошибка", message: "Невозможно перейти к профилю")
                            return
                        }
                        navigationController.pushViewController(myProfileView, animated: true)
                    }
                } catch {
                    print("Ошибка подключения или выполнения запроса: \(error.localizedDescription)")
                    DispatchQueue.main.async {
                        self.showAlert(title: "Внимание!", message: "Ошибка ввода данных")
                    }
                }
            }
        }



        private func showAlert(title: String, message: String) {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "ОК", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
}
