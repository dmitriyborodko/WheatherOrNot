import UIKit

class Coordinator {

    var rootVC: UIViewController { weatherNavigationController }

    private let weatherNavigationController = UINavigationController()
    private let weatherVC = WeatherVC()

    init() {
        configureUI()
    }

    private func configureUI() {
        weatherNavigationController.setViewControllers([weatherVC], animated: false)
    }
}
