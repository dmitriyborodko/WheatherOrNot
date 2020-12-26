import UIKit

class WeatherVC: UIViewController {

    private lazy var weatherOverallView: WeatherOverallView = .init()

    override func loadView() {
        self.view = UIView()

        configureUI()
    }

    private func configureUI() {
        view.backgroundColor = .systemTeal
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
}
