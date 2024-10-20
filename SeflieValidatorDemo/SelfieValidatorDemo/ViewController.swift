//
//  ViewController.swift
//  SelfieValidatorDemo
//
//  Created by Ahmed Attalla on 19/10/2024.
//

import UIKit
import SelfieValidatorFramework

class ViewController: UIViewController {

    @IBOutlet weak var capturedPhotoImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSelfieValidatorDelegate()
    }
    
    private func configureSelfieValidatorDelegate() {
        SelfieValidatorFramework.Configurations.setup(delegate: self)
    }
    
    @IBAction func startOnboardingButtonTapped(_ sender: Any) {
        let cameraViewController = SelfieValidatorFramework.getSelfieValidationScene()
        let navigationController = UINavigationController(rootViewController: cameraViewController)
        navigationController.modalPresentationStyle = .fullScreen
        present(navigationController, animated: true)
    }
}

extension ViewController: SelfieValidatorDelegate {
    func didCaptureSelfie(_ image: UIImage) {
        capturedPhotoImageView.image = image
    }
}
