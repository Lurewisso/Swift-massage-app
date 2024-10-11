

import UIKit



//описывает настройки начального состояния  приложения iOS с использованием SceneDelegate. Вот разбор ключевых частей:
//SceneDelegate — это класс, который управляет жизненным циклом сцены (или окна) в приложении.
//UIWindowSceneDelegate — это протокол, который определяет методы для управления сценой, такие как установка начального интерфейса.

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = scene as? UIWindowScene else { return }
        window = UIWindow(windowScene: windowScene)
        let navigationController = UINavigationController(rootViewController: MainViewController())
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
}


//Этот метод вызывается, когда сцена готова к подключению, и используется для настройки начального состояния интерфейса приложения.
//scene — это объект UIScene, который представляет текущую сцену (или окно) приложения.
//session — это объект UISceneSession, который содержит информацию о сессии сцены.
//connectionOptions — это объект UIScene.ConnectionOptions, который содержит информацию о том, как сцена была запущена (например, с помощью URL-адресов или пользовательских данных).
