
import UIKit
import Foundation

class MenuViewController: UIViewController {

    enum MenuOptions: String, CaseIterable {
        case myprofile = "Личный кабинет"
        case reccomend = "Рекомендации"
        case myworks = "Мои работы"
        case address = "Адрес салона"
        case contract = "Противопоказания"
        case authorCourse = "Авторские курсы"
        case submitUApp = "Оставить заявку"
        case settings = "Настройки"
        case help = "Помощь"
        case raspisanie = "Расписание сеансов"
        case spisokVsego = "Сетка сеансов"

    }

    weak var delegate: MenuViewControllerDelegate?

    private let tableView: UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
//        table.backgroundColor = .systemGray6
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let isDarkMode = UserDefaults.standard.bool(forKey: "isDarkMode")
//        updateAppBackground(isDarkMode: isDarkMode)
        
//        view.backgroundColor = .systemGray6
//        tableView.delegate = self устанавливает текущий объект как делегат для tableView. Делегат отвечает за обработку событий таблицы (например, выбор строки).
//        tableView.dataSource = self устанавливает текущий объект как источник данных для tableView. Источник данных предоставляет данные для таблицы, такие как количество строк и содержимое ячеек.
        tableView.delegate = self
        tableView.dataSource = self

        view.addSubview(tableView)
        tableView.frame = view.bounds
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let isDarkMode = UserDefaults.standard.bool(forKey: "isDarkMode")
        updateAppBackground(isDarkMode: isDarkMode)
    }
    

}

//Этот код расширяет класс MenuViewController, чтобы реализовать два протокола: UITableViewDelegate и UITableViewDataSource. Эти протоколы позволяют MenuViewController управлять и предоставлять данные для UITableView. Вот разбор кода:
//Это расширение добавляет поддержку протоколов UITableViewDelegate и UITableViewDataSource к классу MenuViewController.
//UITableViewDelegate управляет взаимодействием с таблицей, например, обработкой выбора строки.
//UITableViewDataSource предоставляет данные для таблицы, такие как количество строк и содержимое ячеек.

extension MenuViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MenuOptions.allCases.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        // Установка текста для ячейки
        cell.textLabel?.text = MenuOptions.allCases[indexPath.row].rawValue
        cell.textLabel?.font = UIFont.systemFont(ofSize: 16)
        
        // Проверка текущей темы и установка цвета текста
        let isDarkMode = UserDefaults.standard.bool(forKey: "isDarkMode")
        cell.textLabel?.textColor = isDarkMode ? .white : .white

        // Установка цвета фона ячейки
        cell.backgroundColor = isDarkMode ? .lightGray : .lightGray

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let selectedItem = MenuOptions.allCases[indexPath.row]
        delegate?.didSelect(menuItem: selectedItem)
    }
    
    func updateAppBackground(isDarkMode: Bool) {
        view.backgroundColor = isDarkMode ? .black : .white
        tableView.backgroundColor = isDarkMode ? .black : .white
        
        // Перезагрузка таблицы, чтобы обновить все ячейки
        tableView.reloadData()
        
        view.setNeedsLayout()
        view.layoutIfNeeded()
    }

   
}

extension MainViewController: MenuViewControllerDelegate {
    

    func didSelect(menuItem: MenuViewController.MenuOptions) {
        menu?.dismiss(animated: true, completion: nil)

        switch menuItem {
        case .myprofile:
            myProfileForm()
        case .reccomend:
            showInformation()
        case .myworks:
            showPhotoPagination()
        case .address:
            showAdress()
        case .contract:
            showcontraindicationsForm()
        case .authorCourse:
            showAuthorForm()
        case .submitUApp:
            showInputForm()
        case .settings:
            settingsForm()
        case .help:
            helpForm()
        case .raspisanie:
            raspisanieForm()
        case .spisokVsego:
            spisokVsegoForm()

        }
        
    }
}
