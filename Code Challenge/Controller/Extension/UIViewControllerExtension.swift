//
//  UIViewControllerExtension.swift
//  Code Challenge
//
//  Created by 230199M99806607 on 17/09/23.
//

import UIKit

extension UIViewController{
    
    static let activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()

    func startLoading() {
        let activityIndicator = UIViewController.activityIndicator
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = .gray
        DispatchQueue.main.async {
            self.view.addSubview(activityIndicator)
        }
        activityIndicator.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
    }

    func stopLoading() {
        let activityIndicator = UIViewController.activityIndicator
        DispatchQueue.main.async {
            activityIndicator.stopAnimating()
            activityIndicator.removeFromSuperview()
        }
        UIApplication.shared.endIgnoringInteractionEvents()
      }
    
    func setBackgroundImage() {
        // Crea una vista de fondo con la imagen deseada
        let backgroundImage = UIImageView(image: UIImage(named: "themoviedb_1"))
        
        // Configura la vista de fondo
        backgroundImage.contentMode = .scaleAspectFill
        backgroundImage.translatesAutoresizingMaskIntoConstraints = false
        
        // Agrega la vista de fondo a la vista principal (asegúrate de que esté detrás de otros elementos)
        view.insertSubview(backgroundImage, at: 0)
        
        // Configura constraints para que la imagen de fondo ocupe toda la vista
        NSLayoutConstraint.activate([
            backgroundImage.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImage.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImage.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundImage.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}
