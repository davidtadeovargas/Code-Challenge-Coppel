//
//  MainViewController.swift
//  Code Challenge
//
//  Created by 230199M99806607 on 17/09/23.
//

import UIKit

class MainViewController: UIViewController, SideMenuDelegate {
    
    var sessionId:String?
    
    private let sideMenuWidth: CGFloat = 250
    private var isSideMenuVisible = false
    private var sideMenuLeadingConstraint: NSLayoutConstraint!
    private let sideMenu = SideMenuViewController()

    // Añade un UISegmentedControl en la parte superior
    private let segmentedControl: UISegmentedControl = {
        let items = [String(localized: "Popular"), String(localized: "Top_Rated"), String(localized: "On_TV"), String(localized: "Airing_Today")]
        let segmentedControl = UISegmentedControl(items: items)
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.addTarget(self, action: #selector(segmentedControlChanged(_:)), for: .valueChanged)
        return segmentedControl
    }()
    
    // Añade un UIContainerView para mostrar el contenido de las pestañas
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // Controladores de vista para cada pestaña
    private lazy var popularViewController: UIViewController = {
        let vc = PopularViewController()
        return vc
    }()
    
    private lazy var topRatedViewController: UIViewController = {
        let vc = TopRatedViewController()
        return vc
    }()
    
    private lazy var onTVViewController: UIViewController = {
        let vc = OnTvViewController()
        return vc
    }()
    
    private lazy var airingTodayViewController: UIViewController = {
        let vc = AiringTodayViewController()
        return vc
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setBackgroundImage()
        
        // Descartar cualquier controlador de vista previo en la pila de navegación
        self.navigationController?.viewControllers = [self]
        
        automaticallyAdjustsScrollViewInsets = false  // Desactiva el ajuste automático de los elementos
        view.backgroundColor = .white
        
        segmentedControl.frame = CGRect(x: 16, y: UIApplication.shared.statusBarFrame.height + 45, width: view.bounds.width - 32, height: 30)

        // Añade el UISegmentedControl en la parte superior
        view.addSubview(segmentedControl)
        segmentedControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8).isActive = true // Ajusta el valor "constant" según sea necesario
        segmentedControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true // Ajusta el valor "constant" según sea necesario
        segmentedControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true // Ajusta el valor "constant" según sea necesario

        // Añade el UIContainerView debajo del UISegmentedControl
        view.addSubview(containerView)
        containerView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 8).isActive = true // Ajusta el valor "constant" según sea necesario
        containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        // Agrega el controlador de vista predeterminado
        displayContentController(popularViewController)
        
        setupSideMenu()
                
        // Utiliza una fuente de iconos más grande y ajusta el tamaño
        let menuIcon = UIImage(systemName: "list.dash")?.withTintColor(.black, renderingMode: .alwaysOriginal).withConfiguration(UIImage.SymbolConfiguration(pointSize: 30, weight: .bold))
        
        let showMenuButton = UIBarButtonItem(image: menuIcon, style: .plain, target: self, action: #selector(toggleSideMenu))
        navigationItem.leftBarButtonItem = showMenuButton
        
    }
    
    private func setupSideMenu() {
        addChild(sideMenu)
        view.addSubview(sideMenu.view)
        
        sideMenu.delegate = self
        
        sideMenu.view.translatesAutoresizingMaskIntoConstraints = false
        sideMenuLeadingConstraint = sideMenu.view.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0) // Cambiar a 0
        
        NSLayoutConstraint.activate([
            sideMenu.view.widthAnchor.constraint(equalToConstant: sideMenuWidth),
            sideMenu.view.topAnchor.constraint(equalTo: view.topAnchor),
            sideMenu.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            sideMenuLeadingConstraint
        ])
        
        // Cambia el color de fondo del Side Menu a blanco
        sideMenu.view.backgroundColor = .white
        
        sideMenu.didMove(toParent: self)
    }

    
    func logout() {
        // Aquí realizas la lógica para cerrar la sesión, por ejemplo, limpiar la información de autenticación.
        
        // Luego, crea una instancia del LoginViewController y establece-o como el controlador de vista raíz.
        let loginViewController = LoginViewController()
        UIApplication.shared.windows.first?.rootViewController = loginViewController
    }


    
    @objc private func toggleSideMenu() {
        isSideMenuVisible.toggle()
        
        if isSideMenuVisible {
            sideMenuLeadingConstraint.constant = 0
        } else {
            sideMenuLeadingConstraint.constant = -sideMenuWidth
        }
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }

    func didSelectMenuItem(item: String) {
        toggleSideMenu() // Oculta el menú después de seleccionar un elemento
        
        // Implementa las acciones de los elementos del menú aquí
        if item == String(localized: "Ver_perfil_del_usuario") {
            
            let userDetailsViewController = UserDetailsViewController()
            userDetailsViewController.sessionId = self.sessionId
            self.navigationController?.pushViewController(userDetailsViewController, animated: true)
            
        } else if item == String(localized: "Cerrar_sesion") {
            logout()
        }
    }

    @objc private func segmentedControlChanged(_ sender: UISegmentedControl) {
        // Muestra el controlador de vista correspondiente al índice seleccionado
        switch sender.selectedSegmentIndex {
        case 0:
            displayContentController(popularViewController)
        case 1:
            displayContentController(topRatedViewController)
        case 2:
            displayContentController(onTVViewController)
        case 3:
            displayContentController(airingTodayViewController)
        default:
            break
        }
    }
    
    private func displayContentController(_ content: UIViewController) {
        // Remueve el controlador de vista actual si existe
        for child in children {
            child.removeFromParent()
            child.view.removeFromSuperview()
        }
        
        // Agrega el nuevo controlador de vista y su vista al UIContainerView
        addChild(content)
        content.view.frame = containerView.bounds
        containerView.addSubview(content.view)
        content.didMove(toParent: self)
    }
}

