import UIKit
import SideMenu
import PostgresClientKit


struct NewsItem {
    
    let title: String
    let description: String
    let detail: String
    
   
}
class NewsDetailViewController: UIViewController {
    

    var newsItem: NewsItem?

    private let detailLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.font = UIFont.systemFont(ofSize: 22)
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(detailLabel)
        
        
//        UserDefaults.standard представляет собой стандартный объект для хранения пользовательских настроек и данных.
//        bool(forKey:) — это метод, который возвращает логическое значение (true или false), связанное с указанным ключом ("isDarkMode" в данном случае). Если ключа нет в UserDefaults, метод возвращает false по умолчанию.
        
        
        let isDarkMode = UserDefaults.standard.bool(forKey: "isDarkMode")
        updateAppBackground(isDarkMode: isDarkMode)

        NSLayoutConstraint.activate([
            detailLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            detailLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            detailLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
        func updateAppBackground(isDarkMode: Bool) {
            view.backgroundColor = isDarkMode ? .darkGray : .white
  
            detailLabel.textColor = isDarkMode ? .white : .black

        }
//        if let — это конструкция для безопасного извлечения значения из опционала. Опционал в Swift представляет собой переменную, которая может содержать значение или быть равной nil.
//        newsItem здесь — это опционал, который может содержать объект типа NewsItem или быть nil.

        if let newsItem = newsItem {
            title = newsItem.title
            detailLabel.text = newsItem.detail
        }
    }
}


class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    let tableView = UITableView()
    var menu: SideMenuNavigationController?
    

    var newsItems: [NewsItem] = [
        NewsItem(title: "Бургеры полезны для здоровья", description: "О нет, бургеры идут!", detail: "Наконец-то подтверждено! Бургеры — это суперфуд. Ученые заявили, что правильный баланс булочек, котлеты и сыра — это секрет долголетия. Исследования показывают, что люди, которые съедают по бургеру в день, становятся счастливее на 99%. Вдобавок, они быстрее решают задачи и лучше спят! Некоторые даже утверждают, что после съеденного бургера почувствовали прилив творческой энергии и начали писать стихи о картошке фри."),
        NewsItem(title: "Новая техника", description: "Вау!!", detail: "Наконец-то изобретение, о котором никто не просил! Умный пылесос теперь не только убирает вашу квартиру, но и болтает с вами о погоде, политике и ценах на картошку. Если вдруг вы одиноки, он может даже намекнуть, что неплохо бы помыть посуду."),
        NewsItem(title: "Картошка убивает", description: "Фри смерть", detail: "Новое исследование учёных показало, что картошка — это настоящий враг! Нет, она не токсична и не содержит ядовитых веществ. Просто, когда вы едите картошку в фастфуде, она так вкусна, что невозможно остановиться! Строго рекомендуется избегать картошки на диете, иначе ваш желудок объявит вас врагом номер один."),
        NewsItem(title: "Пончики зло", description: "Круглый как мир", detail: "Они выглядят такими невинными — круглыми, сладкими и покрытыми глазурью, но не обманывайтесь! Пончики — это хитрый заговор кондитеров. Каждый пончик, который вы съедаете, тайно добавляет пару лишних граммов к вашей талии. Будьте начеку и не поддавайтесь их сладким обещаниям!"),
        NewsItem(title: "Мак на высоте", description: "Кому свежих яблок?", detail: "Новейшее обновление Mac OS действительно подняло планку… правда, вместе с ней поднялись и цены на устройства Apple! Теперь даже сама система намекает: 'Не забудь обновить кредитную карту'. Если продолжить в том же духе, скоро придётся залезать на крышу, чтобы установить новую версию."),
        NewsItem(title: "Зеленая роща", description: "Грин роща", detail: "В ближайшем парке завёлся новый тренд — фитнес среди деревьев! Вдохните свежий воздух, обнимите дерево и ощутите связь с природой. А если вам повезёт, то за соседним кустом можно встретить единорога, предлагающего экологически чистый детокс."),
        NewsItem(title: "Розовый слон", description: "И не такое видели!", detail: "Очевидцы сообщают, что в местном зоопарке появился новый обитатель — розовый слон! Зоопарк утверждает, что это просто очень редкий вид, но мы все знаем правду. Розовые слоны появляются, когда слишком много думаешь о тортах. Особенно розовых."),
        NewsItem(title: "Оз великий и ужасный", description: "Как страшно!", detail: "После того как его тайна раскрылась, и стало известно, что он — всего лишь обычный человек за занавеской, Оз решил: 'Достаточно прятаться!'. Теперь он проводит мастер-классы по психологии и самооценке. Его главный совет: 'Будь собой, даже если все думают, что ты волшебник!' Его популярность настолько велика, что на последний семинар пришли все жители Изумрудного города, включая Летучих Обезьян, которые теперь работают личными тренерами."),
        NewsItem(title: "Блог на ютюб", description: "Ох уж эти блогеры", detail: "Кажется, что завести свой блог на YouTube теперь может даже ваша бабушка — и вот она уже имеет больше подписчиков, чем вы! В новом тренде 'Бабушкины советы' каналы набирают миллионы просмотров. Видео под названием 'Как правильно завязывать платок на рынке' и 'Советы по приготовлению супа от трёх до пяти литров' стали настоящими хитами. Следите за новыми выпусками, ведь скоро там появятся уроки по вязанию носков с углубленным анализом политической ситуации."),
        NewsItem(title: "Новости на первом", description: "Шоу!!", detail: "'Новости на первом' продолжают удивлять своих зрителей. В последнем выпуске, вместо традиционных политических дебатов, ведущие вдруг решили провести танцевальный баттл! Зрители с восторгом наблюдали за тем, как ведущий спортивных новостей пытался исполнить брейк-данс, а экономист канала делал сальто. Теперь каждый вечер — это не просто новости, а настоящее шоу, где можно узнать, кто из политиков лучше танцует сальсу!")
    ]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Настройка TableView
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(NewsCell.self, forCellReuseIdentifier: "NewsCell")
        tableView.frame = view.bounds
        tableView.rowHeight = 130
        view.addSubview(tableView)

        // Настройка навигационной панели с кнопкой гамбургера
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "line.horizontal.3"), style: .plain, target: self, action: #selector(didTapMenuButton))

        // Настройка иконки профиля
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "person.crop.circle"), style: .plain, target: self, action: #selector(didTapProfileButton))

        // Настройка меню
        let menuVC = MenuViewController()
        menuVC.delegate = self
        menu = SideMenuNavigationController(rootViewController: menuVC)
        menu?.leftSide = true

        // Настройка дополнительных параметров меню
        var settings = SideMenuSettings()
        settings.presentationStyle = .menuSlideIn
        settings.menuWidth = max(round(min((UIScreen.main.bounds.width), (UIScreen.main.bounds.height)) * 0.75), 240)
        settings.statusBarEndAlpha = 0

        menu?.settings = settings

        
        SideMenuManager.default.leftMenuNavigationController = menu
        SideMenuManager.default.addPanGestureToPresent(toView: self.view)
        SideMenuManager.default.addScreenEdgePanGesturesToPresent(toView: self.view, forMenu: .left)
        
       
    }
    
//    Это метод делегата UITableView, который вызывается, когда пользователь выбирает строку в таблице.
//    tableView — это объект UITableView, в котором была выбрана строка.
//    indexPath — это индекс выбранной строки, который содержит информацию о секции и строке в таблице.
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let selectedNewsItem = newsItems[indexPath.row]
        
//        NewsDetailViewController — это контроллер представления (или экран), который отображает подробности о выбранной новости.
//        Создаётся новый экземпляр NewsDetailViewController.
//        Свойство newsItem этого контроллера устанавливается на selectedNewsItem, чтобы передать информацию о выбранной новости на новый экран.
        
        let detailVC = NewsDetailViewController()
        detailVC.newsItem = selectedNewsItem
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let isDarkMode = UserDefaults.standard.bool(forKey: "isDarkMode")
        updateAppBackground(isDarkMode: isDarkMode)
        
        func updateAppBackground(isDarkMode: Bool) {
            view.backgroundColor = isDarkMode ? .darkGray : .white
            tableView.backgroundColor = isDarkMode ? .black : .white
            
            
            tableView.reloadData()
        }
        

    }
    
    
    
    @objc func didTapMenuButton() {
        guard let menu = menu else { return }
        present(menu, animated: true, completion: nil)
    }

    @objc func didTapProfileButton() {
        let loginVC = LoginViewController2()
//        let loginVC = EnterViewController()
        present(loginVC, animated: true, completion: nil)
    }
    
    
    @objc func showInformation() {
            let infoVC = InformationViewController()
            navigationController?.pushViewController(infoVC, animated: true)
        }

    @objc func showPhotoPagination() {
           let photoVC = PhotoPaginationViewController()
           navigationController?.pushViewController(photoVC, animated: true)
       }
       
    @objc func showAdress() {
           let adressVC = GetAdress()
           navigationController?.pushViewController(adressVC, animated: true)
       }
       
       @objc func showInputForm() {
           let inputVC = InputFormViewController()
           navigationController?.pushViewController(inputVC, animated: true)
       }
       
       @objc func showcontraindicationsForm() {
           let contraindicationsVC = ContraindicationsViewController()
           navigationController?.pushViewController(contraindicationsVC, animated: true)
       }
       
       @objc func showAuthorForm() {
           let authorVC = AuthorViewController()
           navigationController?.pushViewController(authorVC, animated: true)
       }
       
       @objc func helpForm() {
           let helpVC = HelpViewController()
           navigationController?.pushViewController(helpVC, animated: true)
       }
       
       @objc func registrForm() {
           let registrVC = RegistrViewController()
           navigationController?.pushViewController(registrVC, animated: true)
       }
       
       @objc func enterForm() {
           let enterVC = EnterViewController()
           navigationController?.pushViewController(enterVC, animated: true)
       }
       
       @objc func settingsForm() {
           let setVC = SettingViewController()
           navigationController?.pushViewController(setVC, animated: true)
       }
    
       @objc func raspisanieForm() {
        let raspVC = RaspisanieViewController()
        navigationController?.pushViewController(raspVC, animated: true)
       }
        
        @objc func spisokVsegoForm() {
        let listVC = AppointmentViewer()
        navigationController?.pushViewController(listVC, animated: true)
      }
    
    
    
        @objc func myProfileForm() {
        let mpVC = MyProfileView()
        navigationController?.pushViewController(mpVC, animated: true)
    }
    
    
    
    // MARK: - TableView Methods

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsItems.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewsCell", for: indexPath) as! NewsCell
        
        let newsItem = newsItems[indexPath.row]
        cell.configure(with: newsItem.title, description: newsItem.description)
        
        
        let isDarkMode = UserDefaults.standard.bool(forKey: "isDarkMode")
        
      
        cell.titleLabel.textColor = isDarkMode ? .black : .black
        cell.descriptionLabel.textColor = isDarkMode ? .white : .white
        cell.containerView.backgroundColor = isDarkMode ? .lightGray : .lightGray
        
        cell.backgroundColor = isDarkMode ? .black : .white
        
        return cell
    }

    
    

}


class NewsCell: UITableViewCell {

 
    //заливка картинок для новостей
    public let newsImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    //ЦВЕТ КАРТОЧЕК  внутри х2!!!
    public let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.numberOfLines = 1
//        label.backgroundColor = .yellow
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    //цвет для описания новостей текст
    public let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .gray
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    //ЦВЕТ КАРТОЧЕК !!!
    public let containerView: UIView = {
        let view = UIView()
//        view.backgroundColor = .purple
        view.layer.cornerRadius = 8
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.1
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 4
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(containerView)
        containerView.addSubview(newsImageView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(descriptionLabel)
        

        

        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            newsImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 8),
            newsImageView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 8),
            newsImageView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -8),
            newsImageView.widthAnchor.constraint(equalTo: newsImageView.heightAnchor),

            titleLabel.leadingAnchor.constraint(equalTo: newsImageView.trailingAnchor, constant: 12),
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -8),

            descriptionLabel.leadingAnchor.constraint(equalTo: newsImageView.trailingAnchor, constant: 12),
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            descriptionLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -8),
            descriptionLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -12)
        ])
    }

    


    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with title: String, description: String) {
        titleLabel.text = title
        descriptionLabel.text = description
        newsImageView.image = UIImage(named: "logo")
    }
    
    func updateAppBackground(isDarkMode: Bool) {
            containerView.backgroundColor = isDarkMode ? .black : .white
            titleLabel.backgroundColor = isDarkMode ? .black : .white
        }
}

// Контроллер для бокового меню
protocol MenuViewControllerDelegate: AnyObject {
    func didSelect(menuItem: MenuViewController.MenuOptions)
}








//@main: Этот атрибут указывает, что класс AppDelegate является точкой входа приложения. Он заменяет необходимость в @UIApplicationMain для обозначения основного класса делегата приложения.


//class AppDelegate: Определяет класс AppDelegate, который наследует от UIResponder и реализует протокол UIApplicationDelegate.


@main
class AppDelegate: UIResponder, UIApplicationDelegate {
//Это свойство представляет собой окно приложения, которое отображает пользовательский интерфейс. Оно используется для установки корневого контроллера.
    var window: UIWindow?
//Этот метод вызывается, когда приложение завершает запуск. Он используется для начальной настройки приложения и подготовки его к работе.
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        
//        Создается экземпляр MainViewController, который является основным (первым) контроллером в приложении.
//        Затем создается экземпляр UINavigationController, который управляет стеком контроллеров навигации и устанавливается начальным контроллером навигации.
        let mainVC = MainViewController()
        let navigationController = UINavigationController(rootViewController: mainVC)

//        window инициализируется с размерами экрана устройства.
//        window?.rootViewController устанавливается как navigationController, который содержит mainVC.
//        window?.makeKeyAndVisible() делает окно видимым и ключевым (т.е. оно становится основным окном для отображения пользовательского интерфейса).
        
        
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()

        return true
    }
}
