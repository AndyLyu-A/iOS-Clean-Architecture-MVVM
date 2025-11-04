import UIKit

final class OnboardingViewController: UIViewController, StoryboardInstantiable {
    
    private var viewModel: OnboardingViewModel!
    
    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var nameTextField: UITextField!
    @IBOutlet private weak var signInButton: UIButton!
    @IBOutlet private weak var signUpButton: UIButton!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
    static func create(with viewModel: OnboardingViewModel) -> OnboardingViewController {
        let viewController = OnboardingViewController.instantiateViewController()
        viewController.viewModel = viewModel
        return viewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        bind(to: viewModel)
    }
    
    private func setupViews() {
        title = "Welcome"
        emailTextField?.placeholder = "Email"
        passwordTextField?.placeholder = "Password"
        passwordTextField?.isSecureTextEntry = true
        nameTextField?.placeholder = "Name (optional)"
        signInButton?.setTitle("Sign In", for: .normal)
        signUpButton?.setTitle("Sign Up", for: .normal)
    }
    
    private func bind(to viewModel: OnboardingViewModel) {
        viewModel.isLoading.observe(on: self) { [weak self] isLoading in
            self?.updateLoadingState(isLoading)
        }
        
        viewModel.error.observe(on: self) { [weak self] error in
            if let error = error {
                self?.showError(error)
            }
        }
    }
    
    private func updateLoadingState(_ isLoading: Bool) {
        signInButton?.isEnabled = !isLoading
        signUpButton?.isEnabled = !isLoading
        if isLoading {
            activityIndicator?.startAnimating()
        } else {
            activityIndicator?.stopAnimating()
        }
    }
    
    @IBAction private func signInButtonTapped(_ sender: UIButton) {
        let email = emailTextField?.text ?? ""
        let password = passwordTextField?.text ?? ""
        viewModel.didTapSignIn(email: email, password: password)
    }
    
    @IBAction private func signUpButtonTapped(_ sender: UIButton) {
        let email = emailTextField?.text ?? ""
        let password = passwordTextField?.text ?? ""
        let name = nameTextField?.text
        viewModel.didTapSignUp(email: email, password: password, name: name)
    }
    
    deinit {
        viewModel.isLoading.remove(observer: self)
        viewModel.error.remove(observer: self)
    }
}

extension OnboardingViewController: Alertable {}
