import UIKit

protocol SideMenuDelegate: AnyObject {
    func didSelectMenuItem(item: String)
}

class SideMenuViewController: UIViewController {
    
    weak var delegate: SideMenuDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        let profileButton = createMenuItem(title: String(localized: "Ver_perfil_del_usuario"), imageName: "person.circle.fill", tintColor: .white)
        let logoutButton = createMenuItem(title: String(localized: "Cerrar_sesion"), imageName: "arrow.left.circle.fill", tintColor: .white)
        
        let stackView = UIStackView(arrangedSubviews: [profileButton, logoutButton])
        stackView.axis = .vertical
        stackView.spacing = 20
        
        view.addSubview(stackView)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }
    
    private func createMenuItem(title: String, imageName: String, tintColor: UIColor) -> UIButton {
        let button = UIButton()
        button.setTitle(title, for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        
        if let image = UIImage(systemName: imageName) {
            let configuredImage = image.withTintColor(tintColor, renderingMode: .alwaysOriginal)
            button.setImage(configuredImage, for: .normal)
        }
        
        button.semanticContentAttribute = .forceRightToLeft
        button.contentHorizontalAlignment = .left
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        
        button.addTarget(self, action: #selector(menuItemTapped(_:)), for: .touchUpInside)
        return button
    }
    
    @objc private func menuItemTapped(_ sender: UIButton) {
        guard let title = sender.currentTitle else { return }
        delegate?.didSelectMenuItem(item: title)
    }
}
