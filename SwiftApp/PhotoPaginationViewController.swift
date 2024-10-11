
import UIKit
import Foundation

class PhotoPaginationViewController: UIViewController {
    var currentIndex = 0
    let photos = ["imgCats","imgCats2", "imgCats3"]
    let backgroundPaggingFormImageView = UIImageView()

    let imageView = UIImageView()
    let nextButton = UIButton()
    let prevButton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
//        setupUI()
        
        let isDarkMode = UserDefaults.standard.bool(forKey: "isDarkMode")
                updateAppBackground(isDarkMode: isDarkMode)
        
//        view.backgroundColor = .white
//        backgroundPaggingFormImageView.image = UIImage(named: "wallpaperBlack")
        backgroundPaggingFormImageView.contentMode = .scaleAspectFill
        backgroundPaggingFormImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(backgroundPaggingFormImageView)
        
        
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)

        nextButton.setTitle("Вперед", for: .normal)
        nextButton.setTitleColor(.white, for: .normal)
//        nextButton.backgroundColor = .blue
        nextButton.layer.cornerRadius = 10
        nextButton.layer.shadowColor = UIColor.black.cgColor
        nextButton.layer.shadowOpacity = 0.5
        nextButton.layer.shadowOffset = CGSize(width: 5, height: 5)
        nextButton.layer.shadowRadius = 5
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        nextButton.addTarget(self, action: #selector(nextPhoto), for: .touchUpInside)
        view.addSubview(nextButton)

        prevButton.setTitle("Назад", for: .normal)
        prevButton.setTitleColor(.white, for: .normal)
//        prevButton.backgroundColor = .blue
        prevButton.layer.cornerRadius = 10
        prevButton.layer.shadowColor = UIColor.black.cgColor
        prevButton.layer.shadowOpacity = 0.5
        prevButton.layer.shadowOffset = CGSize(width: 5, height: 5)
        prevButton.layer.shadowRadius = 5
        prevButton.translatesAutoresizingMaskIntoConstraints = false
        prevButton.addTarget(self, action: #selector(prevPhoto), for: .touchUpInside)
        view.addSubview(prevButton)

        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 400),
            imageView.heightAnchor.constraint(equalToConstant: 300),

            nextButton.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: -160),
            nextButton.centerYAnchor.constraint(equalTo: imageView.centerYAnchor, constant: 170),
            nextButton.widthAnchor.constraint(equalToConstant: 150),
            nextButton.heightAnchor.constraint(equalToConstant: 50),

            prevButton.trailingAnchor.constraint(equalTo: imageView.leadingAnchor, constant: 160),
            prevButton.centerYAnchor.constraint(equalTo: imageView.centerYAnchor,constant: 170),
            prevButton.widthAnchor.constraint(equalToConstant: 150),
            prevButton.heightAnchor.constraint(equalToConstant: 50),
            
            backgroundPaggingFormImageView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundPaggingFormImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundPaggingFormImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundPaggingFormImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        showPhoto()
    }
    @objc func nextPhoto() {
           currentIndex = (currentIndex + 1) % photos.count
           showPhoto()
       }

       @objc func prevPhoto() {
           currentIndex = (currentIndex - 1 + photos.count) % photos.count
           showPhoto()
       }

       func showPhoto() {
           let imageName = photos[currentIndex]
           imageView.image = UIImage(named: imageName)
       }
    
        func updateAppBackground(isDarkMode: Bool) {
            view.backgroundColor = isDarkMode ? .black : .systemGray2
            nextButton.backgroundColor = isDarkMode ? .systemRed : .systemBlue
            prevButton.backgroundColor = isDarkMode ? .systemRed : .systemBlue
        }

}
