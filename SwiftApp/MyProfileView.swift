import UIKit
import Foundation
import PostgresClientKit

class MyProfileView: UIViewController {
    
    let appIcon = UIImageView()
    let nameLabel = UILabel()
    let surnameLabel = UILabel()
    let phoneNumberLabel = UILabel()
    let changeAvatarButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let isDarkMode = UserDefaults.standard.bool(forKey: "isDarkMode")
        updateAppBackground(isDarkMode: isDarkMode)
        
        appIcon.image = UIImage(named: "myphoto")
        appIcon.contentMode = .scaleAspectFit
        appIcon.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(appIcon)
        
        nameLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        nameLabel.textColor = .black
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nameLabel)
        
        surnameLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        surnameLabel.textColor = .black
        surnameLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(surnameLabel)
        
        phoneNumberLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        phoneNumberLabel.textColor = .black
        phoneNumberLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(phoneNumberLabel)
        
        changeAvatarButton.setTitle("Изменить аватарку", for: .normal)
        changeAvatarButton.setTitleColor(.blue, for: .normal)
        changeAvatarButton.translatesAutoresizingMaskIntoConstraints = false
        changeAvatarButton.addTarget(self, action: #selector(changeAvatarTapped), for: .touchUpInside)
        view.addSubview(changeAvatarButton)
        
        NSLayoutConstraint.activate([
            appIcon.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            appIcon.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100),
            appIcon.widthAnchor.constraint(equalToConstant: 350),
            appIcon.heightAnchor.constraint(equalToConstant: 250),
            
            nameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nameLabel.topAnchor.constraint(equalTo: appIcon.bottomAnchor, constant: 20),
            nameLabel.widthAnchor.constraint(equalToConstant: 250),
            nameLabel.heightAnchor.constraint(equalToConstant: 20),
            
            surnameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            surnameLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 20),
            surnameLabel.widthAnchor.constraint(equalToConstant: 250),
            surnameLabel.heightAnchor.constraint(equalToConstant: 20),
            
            phoneNumberLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            phoneNumberLabel.topAnchor.constraint(equalTo: surnameLabel.bottomAnchor, constant: 20),
            phoneNumberLabel.widthAnchor.constraint(equalToConstant: 250),
            phoneNumberLabel.heightAnchor.constraint(equalToConstant: 20),
            
            changeAvatarButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            changeAvatarButton.topAnchor.constraint(equalTo: phoneNumberLabel.bottomAnchor, constant: 20),
            changeAvatarButton.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    func updateAppBackground(isDarkMode: Bool) {
        view.backgroundColor = isDarkMode ? .black : .systemGray2
        nameLabel.backgroundColor = .white
        surnameLabel.backgroundColor = .white
        phoneNumberLabel.backgroundColor = .white
    }
    
    @objc func changeAvatarTapped() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
}

extension MyProfileView: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[.originalImage] as? UIImage {
            appIcon.image = selectedImage
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}

//    func fetchUserData() {
//        DispatchQueue.global(qos: .background).async {
//            do {
//                var configuration = PostgresClientKit.ConnectionConfiguration()
//                configuration.host = "localhost"
//                configuration.database = "postgres"
//                configuration.user = "postgres"
//                configuration.ssl = false
//                configuration.port = 5432
//                configuration.credential = .scramSHA256(password: "postgres")
//                
//                let connection = try PostgresClientKit.Connection(configuration: configuration)
//                defer { connection.close() }
//                
//                let text = "SELECT name, surname, phone FROM main_client_base WHERE mail = $1;"
//                let statement = try connection.prepareStatement(text: text)
//                defer { statement.close() }
//                
//                let email = "lurewisso@list.ru"
//                let cursor = try statement.execute(parameterValues: [email])
//                defer { cursor.close() }
//                
//                if let row = try cursor.next() {
//                    let name = try row.string(forColumn: "name")
//                    let surname = try row.string(forColumn: "surname")
//                    let phone = try row.string(forColumn: "phone")
//                    
//                    DispatchQueue.main.async {
//                        self.nameLabel.text = "Name: \(name)"
//                        self.surnameLabel.text = "Surname: \(surname)"
//                        self.phoneNumberLabel.text = "Phone number: \(phone)"
//                    }
//                } else {
//                    print("No rows returned")
//                }
//            } catch {
//                print("Ошибка подключения или выполнения запроса: \(error.localizedDescription)")
//            }
//        }
//    }

