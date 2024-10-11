import UIKit
import Foundation

import PostgresClientKit



class RaspisanieViewController: UIViewController {
    
    private var selectedDayButton: UIButton?
    private var timePicker: UIPickerView!
    private var confirmButton: UIButton!
    private var deleteButton: UIButton!
    private var availableTimes: [String] = []
    
    private let daysOfWeek: [String] = ["Понедельник", "Вторник", "Среда", "Четверг", "Пятница", "Суббота", "Воскресенье"]
    private let sessionTimes: [String] = ["10:00", "12:00", "14:00", "16:00", "18:00"]
    
    private var selectedDay: String?
    private var selectedTime: String?
    private var userName: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        let isDarkMode = UserDefaults.standard.bool(forKey: "isDarkMode")
        updateAppBackground(isDarkMode: isDarkMode)
    }
    
    func updateAppBackground(isDarkMode: Bool) {
        view.backgroundColor = isDarkMode ? .black : .systemGray2
        
    }
    private func setupUI() {
        let titleLabel = UILabel()
        titleLabel.text = "Выберите день и время записи"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        titleLabel.textAlignment = .center
        view.addSubview(titleLabel)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 50),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        
        for day in daysOfWeek {
            let button = UIButton(type: .system)
            button.setTitle(day, for: .normal)
            button.setTitleColor(.white, for: .normal)
            button.backgroundColor = UIColor.systemBlue
            button.layer.cornerRadius = 10
            button.addTarget(self, action: #selector(dayButtonTapped(_:)), for: .touchUpInside)
            stackView.addArrangedSubview(button)
        }
        
        view.addSubview(stackView)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            stackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            stackView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5)
        ])
        
        timePicker = UIPickerView()
        timePicker.dataSource = self
        timePicker.delegate = self
    
        timePicker.isHidden = true
        view.addSubview(timePicker)
        
        timePicker.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            timePicker.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            timePicker.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            timePicker.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100),
            timePicker.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.3)
        ])
        
        confirmButton = UIButton(type: .system)
        confirmButton.setTitle("Подтвердить запись", for: .normal)
        confirmButton.setTitleColor(.white, for: .normal)
        confirmButton.backgroundColor = .systemGreen
        confirmButton.layer.cornerRadius = 10
        confirmButton.isHidden = true
        confirmButton.addTarget(self, action: #selector(confirmButtonTapped), for: .touchUpInside)
        view.addSubview(confirmButton)
        
        confirmButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            confirmButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            confirmButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            confirmButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20),
            confirmButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        deleteButton = UIButton(type: .system)
        deleteButton.setTitle("Удалить запись", for: .normal)
        deleteButton.setTitleColor(.white, for: .normal)
        deleteButton.backgroundColor = .systemRed
        deleteButton.layer.cornerRadius = 10
        deleteButton.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
        view.addSubview(deleteButton)
        
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            deleteButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            deleteButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            deleteButton.bottomAnchor.constraint(equalTo: confirmButton.topAnchor, constant: -10),
            deleteButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    @objc private func dayButtonTapped(_ sender: UIButton) {
        selectedDayButton?.backgroundColor = .systemBlue
        selectedDayButton = sender
        selectedDayButton?.backgroundColor = .gray
        
        selectedDay = sender.title(for: .normal)
        availableTimes = sessionTimes
        
        timePicker.isHidden = false
        
        timePicker.reloadAllComponents()
        
        confirmButton.isHidden = true
    }
    
    @objc private func confirmButtonTapped() {
        let alertController = UIAlertController(title: "Введите имя", message: nil, preferredStyle: .alert)
        alertController.addTextField { textField in
            textField.placeholder = "Имя"
        }
        
        let confirmAction = UIAlertAction(title: "Подтвердить", style: .default) { [weak self] _ in
            if let name = alertController.textFields?.first?.text, !name.isEmpty {
                self?.userName = name
                self?.checkAvailabilityAndProceed(name: name)
            } else {
                self?.showErrorAlert(message: "Пожалуйста, введите имя.")
            }
        }
        
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
        
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    private func checkAvailabilityAndProceed(name: String) {
        guard let selectedDay = selectedDay, let selectedTime = selectedTime else {
            showErrorAlert(message: "Пожалуйста, выберите день и время.")
            return
        }
        
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
                
                let checkQuery = "SELECT COUNT(*) FROM raspisanie WHERE day = $1 AND time = $2;"
                let checkStatement = try connection.prepareStatement(text: checkQuery)
                defer { checkStatement.close() }
                
                let result = try checkStatement.execute(parameterValues: [selectedDay, selectedTime])
                var isTimeOccupied = false
                
                for row in result {
                    let columns = try row.get().columns
                    if let count = try columns[0].optionalInt(), count > 0 {
                        isTimeOccupied = true
                    }
                }
                
                DispatchQueue.main.async {
                    if isTimeOccupied {
                        self.showErrorAlert(message: "Данное время уже занято.")
                    } else {
                        self.sendDataToServer(name: name)
                    }
                }
            } catch {
                print("Ошибка подключения или выполнения запроса: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    self.showErrorAlert(message: "Ошибка при проверке наличия записи в базе данных.")
                }
            }
        }
    }
    
    private func sendDataToServer(name: String) {
        guard let selectedDay = selectedDay, let selectedTime = selectedTime else {
            showErrorAlert(message: "Пожалуйста, выберите день и время.")
            return
        }
        
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
                
                let text = "INSERT INTO raspisanie (name, day, time) VALUES ($1, $2, $3);"
                let statement = try connection.prepareStatement(text: text)
                defer { statement.close() }
                
                try statement.execute(parameterValues: [name, selectedDay, selectedTime])
                
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "Успех", message: "Вы записались на \(selectedDay) в \(selectedTime).", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "ОК", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            } catch {
                print("Ошибка подключения или выполнения запроса: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    self.showErrorAlert(message: "Ошибка при записи в базу данных.")
                }
            }
        }
    }
    
    @objc private func deleteButtonTapped() {
        let alertController = UIAlertController(title: "Удалить запись", message: "Введите имя, день и время в точности как при записи на сеанс", preferredStyle: .alert)
        
        alertController.addTextField { textField in
            textField.placeholder = "Имя"
        }
        alertController.addTextField { textField in
            textField.placeholder = "День (например, Понедельник)"
        }
        alertController.addTextField { textField in
            textField.placeholder = "Время (например, 10:00)"
        }
        
        let deleteAction = UIAlertAction(title: "Удалить", style: .destructive) { [weak self] _ in
            guard let self = self else { return }
            
            if let name = alertController.textFields?[0].text,
               let day = alertController.textFields?[1].text,
               let time = alertController.textFields?[2].text,
               !name.isEmpty, !day.isEmpty, !time.isEmpty {
                self.deleteAppointment(name: name, day: day, time: time)
            } else {
                self.showErrorAlert(message: "Пожалуйста, заполните все поля.")
            }
        }
        
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
        
        alertController.addAction(deleteAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    private func deleteAppointment(name: String, day: String, time: String) {
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
                
                let text = "DELETE FROM raspisanie WHERE name = $1 AND day = $2 AND time = $3;"
                let statement = try connection.prepareStatement(text: text)
                defer { statement.close() }
                
                try statement.execute(parameterValues: [name, day, time])
                
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "Успех", message: "Запись успешно удалена.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "ОК", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            } catch {
                print("Ошибка подключения или выполнения запроса: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    self.showErrorAlert(message: "Ошибка при удалении записи.")
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

    

extension RaspisanieViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
            let label = UILabel()
            label.textAlignment = .center
            label.text = availableTimes[row]
            label.textColor = .white
            label.backgroundColor = .systemBlue
            label.font = UIFont.systemFont(ofSize: 26, weight: .bold)
        
            return label
        }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return availableTimes.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return availableTimes[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedTime = availableTimes[row]
        confirmButton.isHidden = false
    }
}
