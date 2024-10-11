
import UIKit
import Foundation


class SettingCell: UITableViewCell {
    let titleLabel = UILabel()
    let toggleSwitch = UISwitch()

//    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?)
//    Это инициализатор, который переопределяет базовый инициализатор init(style:reuseIdentifier:) родительского класса UITableViewCell.
//    Параметры:
//    style: Определяет стиль ячейки (например, .default, .subtitle, .value1, .value2).
//    reuseIdentifier: Идентификатор для повторного использования ячейки. Используется для оптимизации производительности, чтобы ячейки можно было переиспользовать.
//    super.init(style: style, reuseIdentifier: reuseIdentifier)
//    Вызов инициализатора родительского класса UITableViewCell с теми же параметрами. Это обеспечивает корректную инициализацию базового класса перед добавлением специфичных для пользовательской ячейки настроек.
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        updateColors()
    }

    
    
//    required init?(coder: NSCoder)
//    Этот инициализатор необходим для поддержки декодирования ячейки из интерфейсных файлов (например, из XIB или Storyboard).
//    Параметр coder используется для декодирования информации о ячейке.
//    fatalError("init(coder:) has not been implemented")
//    Метод вызывает ошибку выполнения, если попытаться создать ячейку из кодированного интерфейса, что означает, что инициализация из XIB или Storyboard не поддерживается в этом случае.
//    Это обычно делается, чтобы предотвратить использование ячейки из интерфейсных файлов, если разработчик предпочитает создавать ячейки программно.
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        toggleSwitch.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(titleLabel)
        contentView.addSubview(toggleSwitch)

        NSLayoutConstraint.activate([
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),

            toggleSwitch.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            toggleSwitch.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20)
        ])
    }

    func updateColors() {
        let isDarkMode = UserDefaults.standard.bool(forKey: "isDarkMode")
        contentView.backgroundColor = isDarkMode ? .black : .white
        titleLabel.textColor = isDarkMode ? .white : .black
    }
}

class SettingViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    let tableView = UITableView()
    let settings = ["Night mode", "Изменить шрифт", "Внешний вид"]

    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()
        updateAppBackground(isDarkMode: UserDefaults.standard.bool(forKey: "isDarkMode"))
    }

    func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(SettingCell.self, forCellReuseIdentifier: "SettingCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    // MARK: - UITableViewDataSource

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settings.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingCell", for: indexPath) as! SettingCell
        cell.titleLabel.text = settings[indexPath.row]
        cell.toggleSwitch.tag = indexPath.row
        cell.toggleSwitch.addTarget(self, action: #selector(toggleSwitchChanged(_:)), for: .valueChanged)
        
        
        if indexPath.row == 0 {
            let isDarkMode = UserDefaults.standard.bool(forKey: "isDarkMode")
            cell.toggleSwitch.isOn = isDarkMode
        }
        
        cell.updateColors()
        return cell
    }

    @objc func toggleSwitchChanged(_ sender: UISwitch) {
        switch sender.tag {
        case 0:
            // Handle Night mode
            let isDarkMode = sender.isOn
            UserDefaults.standard.set(isDarkMode, forKey: "isDarkMode")
            updateAppBackground(isDarkMode: isDarkMode)
        case 1:
            //  Изменить шрифт
            print("Изменить шрифт toggled: \(sender.isOn)")
        case 2:
            //  Внешний вид
            print("Внешний вид toggled: \(sender.isOn)")
        default:
            break
        }
    }

    func updateAppBackground(isDarkMode: Bool) {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first else { return }

        window.backgroundColor = isDarkMode ? .black : .white
        view.backgroundColor = isDarkMode ? .black : .white
        tableView.backgroundColor = isDarkMode ? .black : .white
        tableView.visibleCells.forEach { cell in
            (cell as? SettingCell)?.updateColors()
        }
    }
}
