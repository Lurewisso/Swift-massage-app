
import UIKit
import Foundation

class ContraindicationsViewController: UIViewController {

    let textView = UITextView()
    let backgroundContraindicationsImageView = UIImageView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        setupUI()
        let isDarkMode = UserDefaults.standard.bool(forKey: "isDarkMode")
                updateAppBackground(isDarkMode: isDarkMode)
        
//        view.backgroundColor = .white
//        backgroundContraindicationsImageView.image = UIImage(named: "wallpaperBlack")
        backgroundContraindicationsImageView.contentMode = .scaleAspectFill
        backgroundContraindicationsImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(backgroundContraindicationsImageView)

        
        textView.translatesAutoresizingMaskIntoConstraints = false
//        textView.layer.borderColor = UIColor.gray.cgColor
        textView.layer.borderWidth = 1.0
        textView.layer.cornerRadius = 10
        textView.font = UIFont.systemFont(ofSize: 18)
//        textView.textColor = .black
        textView.isEditable = false
//        textView.backgroundColor = .white
        textView.isScrollEnabled = true
        textView.borderStyle = .none
        textView.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        textView.text = """
        📌 Противопоказания к массажу:
        
        ⛔️ Аутоимунные заболевания️
        ⛔️ Сахарный диабет
        ⛔️ Сердечно - сосудистые заболевания
        ⛔️ Новообразования
        ⛔️ Онкология
        ⛔️ Тромбозы, тромбофлебиты
        ⛔️ Миомы, кисты, полипы (строго по разрешению врача)
        ⛔️ Воспалительные процессы в организме

        ❗️Важно! Вы должны сообщать мне о ваших любых хронических заболеваниях
        ❗️Также необходимо сообщить если у вас в организме есть металл(спицы, пластины и т.д.)
        ❗️После естественных родов на сеанс можно не ранне, чем через 4 месяца
        ❗️После кесарево должно пройти не менее 6 месяцев
        """
        view.addSubview(textView)

        
        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            textView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            textView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            textView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            
            backgroundContraindicationsImageView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundContraindicationsImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundContraindicationsImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundContraindicationsImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    func updateAppBackground(isDarkMode: Bool) {
            view.backgroundColor = isDarkMode ? .black : .white
            textView.backgroundColor = isDarkMode ? .lightGray : .white
            textView.textColor = isDarkMode ? .white : .black
        }
}
