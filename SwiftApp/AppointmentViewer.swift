
import Foundation
import UIKit
import PostgresClientKit



class AppointmentViewer: UIViewController {
    
    private var appointmentsTextView: UITextView!
    private var titleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "backgroundColor") ?? UIColor.white
        setupUI()
        fetchAndDisplayAppointments()
    }
    
    private func setupUI() {
        // Добавляем эффект тени и округление для заголовка
        titleLabel = UILabel()
        titleLabel.text = "Все записи"
        titleLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        titleLabel.textAlignment = .center
        titleLabel.textColor = UIColor(named: "titleColor") ?? UIColor.black
        titleLabel.layer.shadowColor = UIColor.black.cgColor
        titleLabel.layer.shadowOffset = CGSize(width: 0, height: 2)
        titleLabel.layer.shadowOpacity = 0.25
        titleLabel.layer.shadowRadius = 4
        view.addSubview(titleLabel)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 80),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        // текстовое поле
        appointmentsTextView = UITextView()
        appointmentsTextView.font = UIFont.systemFont(ofSize: 16)
        appointmentsTextView.textColor = UIColor(named: "textColor") ?? UIColor.darkGray
        appointmentsTextView.backgroundColor = UIColor(named: "textViewBackgroundColor") ?? UIColor.white
        appointmentsTextView.isEditable = false
        appointmentsTextView.layer.cornerRadius = 12
        appointmentsTextView.layer.shadowColor = UIColor.black.cgColor
        appointmentsTextView.layer.shadowOffset = CGSize(width: 0, height: 4)
        appointmentsTextView.layer.shadowOpacity = 0.2
        appointmentsTextView.layer.shadowRadius = 8
        appointmentsTextView.textContainerInset = UIEdgeInsets(top: 20, left: 15, bottom: 20, right: 15)
        view.addSubview(appointmentsTextView)
        
        appointmentsTextView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            appointmentsTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            appointmentsTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            appointmentsTextView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            appointmentsTextView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -40)
        ])
        
        // градиентный фон для всего View
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor(named: "gradientStartColor")?.cgColor ?? UIColor.systemMint.cgColor,
            UIColor(named: "gradientEndColor")?.cgColor ?? UIColor.systemBlue.cgColor
        ]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = view.bounds
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    private func fetchAndDisplayAppointments() {
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
                
                let query = "SELECT name, day, time FROM raspisanie ORDER BY day, time;"
                let statement = try connection.prepareStatement(text: query)
                defer { statement.close() }
                
                let result = try statement.execute()
                var appointments: [String] = []
                
                let xname = "Имя скрыто"
                
                for row in result {
                    let columns = try row.get().columns
                    if let name = try columns[0].optionalString(),
                       let day = try columns[1].optionalString(),
                       let time = try columns[2].optionalString() {
                        
                        
                        let appointment  = """
                        Имя: \(xname)\nДень: \(day)\nВремя: \(time)
                        -----------------
                        """
                        appointments.append(appointment)
                    }
                }
                
                DispatchQueue.main.async {
                    self.appointmentsTextView.text = appointments.isEmpty ? "Записей не найдено." : appointments.joined(separator: "\n\n")
                }
            } catch {
                print("Ошибка подключения или выполнения запроса: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    self.showErrorAlert(message: "Ошибка при загрузке данных.")
                }
            }
        }
    }
    
    private func showErrorAlert(message: String) {
        let alert = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "ОК", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
