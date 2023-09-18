//
//  ViewController.swift
//  Code Challenge
//
//  Created by 230199M99806607 on 17/09/23.
//

import UIKit

class LoginViewController: UIViewController {
    
    var requestToken:String?
    
    // Login button
    private let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(String(localized: "Authenticate"), for: .normal)
        button.layer.cornerRadius = 5
        button.backgroundColor = .systemBlue
        button.tintColor = .white
        button.addTarget(self, action: #selector(authenticateButtonPressed), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        initViews()
        
        // Establece la imagen de fondo
        setBackgroundImage()
    }
    
    private func initViews(){
        
        view.backgroundColor = .white
        
        // Add subviews
        view.addSubview(loginButton)
        
        // Set up constraints
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        
        // Cambia la restricción centerYAnchor para bajar el botón
        NSLayoutConstraint.activate([
            loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 120),
            loginButton.widthAnchor.constraint(equalToConstant: 200),
            loginButton.heightAnchor.constraint(equalToConstant: 40)
        ])

    }
    
    @objc func authenticateButtonPressed() {
        
        let moviesRequest = MoviesRequest(onSuccessCreateRequestTokenRequest: { createRequestTokenResponse in
            
            self.onSuccessLocal(createRequestTokenResponse:createRequestTokenResponse)
            
        }, onError: { error in
            
        })
        moviesRequest.endpoint = Constants.CREATE_REQUEST_TOKEN_ENDPOINT
        moviesRequest.request()
    }
    
    private func onSuccessLocal(createRequestTokenResponse:CreateRequestTokenResponse?) {
        
        // Tu código de éxito aquí
        print(String(localized: "Success") + ": \(createRequestTokenResponse!.success)")
        print(String(localized: "Expires_At") + ": \(createRequestTokenResponse!.expires_at)")
        print(String(localized: "Request_Token") + ": \(createRequestTokenResponse!.request_token)")
        
        self.requestToken = createRequestTokenResponse!.request_token
        
        //Open the authentication browser
        DispatchQueue.main.async {
            
            let browserViewController = AuthenticationBrowserViewController()
            browserViewController.requestToken = createRequestTokenResponse?.request_token
            browserViewController.onSuccess = {
                self.onSuccessAuthenticationLocal()
            }
            browserViewController.onNotSuccess = {
                
            }
            self.navigationController?.pushViewController(browserViewController, animated: true)
        }
    }
    
    private func onSuccessAuthenticationLocal() {
            
        let createSessionRequest = CreateSessionRequest(requestToken: self.requestToken!, onSuccess: { createSessionResponse in
            self.onSuccessSessionRequestLocal(createSessionResponse:createSessionResponse)
        }, onError: { error in
            
        })
        createSessionRequest.request()
    }
    
    private func onSuccessSessionRequestLocal(createSessionResponse:CreateSessionResponse?){
        
        DispatchQueue.main.async {
            
            let mainViewController = MainViewController()
            mainViewController.sessionId = createSessionResponse!.session_id
            self.navigationController?.pushViewController(mainViewController, animated: true)
        }
    }
}

