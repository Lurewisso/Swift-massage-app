
import UIKit
import Foundation

class InformationViewController: UIViewController {

    let textView = UITextView()
    let backgroundreccomendImageView = UIImageView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        setupUI()
        
        let isDarkMode = UserDefaults.standard.bool(forKey: "isDarkMode")
                updateAppBackground(isDarkMode: isDarkMode)
        
//        view.backgroundColor = .white
//        backgroundreccomendImageView.image = UIImage(named: "wallpaperBlack")
        backgroundreccomendImageView.contentMode = .scaleAspectFill
        backgroundreccomendImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(backgroundreccomendImageView)

        
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.layer.borderColor = UIColor.gray.cgColor
        textView.layer.borderWidth = 1.0
        textView.layer.cornerRadius = 10
        textView.font = UIFont.systemFont(ofSize: 18)
//        textView.textColor = .black
        textView.isEditable = false
        textView.isScrollEnabled = true
        textView.borderStyle = .none
        textView.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)  // Добавление отступов
        textView.text = """
        Дорогие клиенты! Чтобы достичь наилучших результатов от процедур массажа для похудения, я рекомендую следующее:
        ----------------------------------------
        1. Соблюдайте регулярность. Для достижения видимых результатов необходимо проходить курсы массажа на постоянной основе.
        ----------------------------------------
        2. Поддерживайте здоровый образ жизни. Дополните массаж регулярными физическими упражнениями, здоровым питанием и достаточным уровнем гидратации (это процесс, при котором клетки и ткани организма получают достаточное количество влаги или жидкости для поддержания их здорового функционирования).
        ----------------------------------------
        3. Слушайте свое тело. Если чувствуете болезненные ощущения или дискомфорт во время массажа, обязательно сообщите мне об этом.
        ----------------------------------------
        Также хочу отметить, что для достижения максимального эффекта рекомендуется избегать использования сомнительных аппаратов для разбивания жира в домашних условиях или без профессионального наблюдения.
        ----------------------------------------
        Помните, ваше здоровье и благополучие - важнейший приоритет! Доверьтесь профессионалам и следуйте рекомендациям для достижения желаемых результатов. Берегите себя!
        """
        view.addSubview(textView)

        
        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            textView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            textView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            textView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            
            backgroundreccomendImageView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundreccomendImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundreccomendImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundreccomendImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    func updateAppBackground(isDarkMode: Bool) {
            view.backgroundColor = isDarkMode ? .black : .white
        textView.backgroundColor = isDarkMode ? .systemGray2 : .white
        textView.textColor = isDarkMode ? .white : .black
        
            
        }
}
