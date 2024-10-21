import UIKit

class CapturedImageViewController: UIViewController {
    
    // MARK: - Properties
    let selfieValidatorManager: SelfieValidatorManager
        
    var image: UIImage? {
        didSet {
            imageView.image = image
        }
    }

    private lazy var approveButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Approve", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(approve), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .green
        button.layer.cornerRadius = 10
        return button
    }()

    private lazy var recaptureButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Recapture", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(recapture), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .red
        button.layer.cornerRadius = 10
        return button
    }()

    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    // MARK: - Initialization
    init(selfieValidatorManager: SelfieValidatorManager) {
        self.selfieValidatorManager = selfieValidatorManager
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: - Methods
    private func setupUI() {
        view.backgroundColor = .white
        setupButtons()
        setupImageView()
    }

    private func setupButtons() {
        view.addSubview(approveButton)
        view.addSubview(recaptureButton)
        
        NSLayoutConstraint.activate([
            approveButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            approveButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            approveButton.widthAnchor.constraint(equalToConstant: 100),
            approveButton.heightAnchor.constraint(equalToConstant: 40),

            recaptureButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            recaptureButton.bottomAnchor.constraint(equalTo: approveButton.topAnchor, constant: -20),
            recaptureButton.widthAnchor.constraint(equalToConstant: 100),
            recaptureButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }

    private func setupImageView() {
        view.addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: recaptureButton.topAnchor, constant: -20)
        ])
    }

    @objc private func approve() {
        selfieValidatorManager.approvePhoto()
        dismiss(animated: true, completion: nil)
    }

    @objc private func recapture() {
        navigationController?.popViewController(animated: true)
    }
}
