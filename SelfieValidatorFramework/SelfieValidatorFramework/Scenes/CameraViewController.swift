import UIKit

class CameraViewController: UIViewController {

    // MARK: - Properties
    private let selfieValidatorManager: SelfieValidatorManager = .init()
    
    private lazy var captureButton: UIButton = {
        let button = UIButton(type: .custom)
        let buttonSize: CGFloat = 80
        button.frame = CGRect(x: (UIScreen.main.bounds.width - buttonSize) / 2, y: UIScreen.main.bounds.height - 100, width: buttonSize, height: buttonSize)
        button.layer.cornerRadius = buttonSize / 2
        button.backgroundColor = .white
        button.layer.borderWidth = 6
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.addTarget(self, action: #selector(captureImage), for: .touchUpInside)
        return button
    }()

    private lazy var closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.backgroundColor = .white
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(close), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSelfieValidatorManager()
        startSelfieValidation()
        setupUI()
        setupCaptureButton()
    }

    // MARK: - Methods
    private func setupUI() {
        view.backgroundColor = .white
        view.addSubview(closeButton)
        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            closeButton.widthAnchor.constraint(equalToConstant: 40),
            closeButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    private func setupSelfieValidatorManager() {
        selfieValidatorManager.selfieValidatorManagerHelper = self
        selfieValidatorManager.selfieValidatorManagerDelegate = self
    }
    
    private func startSelfieValidation() {
        do {
            try selfieValidatorManager.start()
        } catch {
            showAlert(message: error.localizedDescription)
        }
    }
    
    private func setupCaptureButton() {
        view.addSubview(captureButton)
    }

    @objc private func captureImage() {
        do {
            try selfieValidatorManager.capturePhoto()
        } catch {
            showAlert(message: error.localizedDescription)
        }
    }

    @objc private func close() {
        dismiss(animated: true, completion: nil)
    }
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Face Detection", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

// MARK: - SelfieValidatorManagerHelper
extension CameraViewController: SelfieValidatorManagerHelper {
    var selfieValidatorViewContainer: UIView {
        self.view
    }
}

// MARK: - SelfieValidatorManagerDelegate
extension CameraViewController: SelfieValidatorManagerDelegate {
    func selfieValidatorManager(_ manager: SelfieValidatorManager, didCapturePhoto photo: UIImage) {
        let vc = CapturedImageViewController(selfieValidatorManager: selfieValidatorManager)
        vc.image = photo
        navigationController?.pushViewController(vc, animated: true)
    }
}

