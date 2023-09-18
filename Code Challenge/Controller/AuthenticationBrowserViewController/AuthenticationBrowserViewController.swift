//
//  BrowserViewController.swift
//  Code Challenge
//
//  Created by 230199M99806607 on 17/09/23.
//

import UIKit
import WebKit

class AuthenticationBrowserViewController: UIViewController, WKNavigationDelegate {

    var webView: WKWebView!
    var url: String?
    var requestToken: String?
    
    var onSuccess: (() -> ())?
    var onNotSuccess: (() -> ())?
    
    var authenticationBrowserModelController:AuthenticationBrowserModelController?
    
    private let baseURL = Constants.BASE_AUTHENTICATE_URL

    override func viewDidLoad() {
        super.viewDidLoad()
        
        initViews()
        
        self.authenticationBrowserModelController = AuthenticationBrowserModelController(uiViewController: self, webView: webView, requestToken: requestToken, onSuccess: onSuccess, onNotSuccess: onNotSuccess)
    }
    
    private func initViews(){
        
        // Verifica si requestToken es nil
        if requestToken == nil {
            // Si requestToken es nil, muestra un UILabel central
            let messageLabel = UILabel()
            messageLabel.text = String(localized: "requestToken_invalid")
            messageLabel.textAlignment = .center
            messageLabel.numberOfLines = 0
            messageLabel.sizeToFit()
            messageLabel.textColor = .white
            messageLabel.center = view.center

            view.addSubview(messageLabel)
        } else {
            
            // Si requestToken no es nil, carga el WKWebView
            webView = WKWebView(frame: view.bounds)
            webView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            webView.navigationDelegate = self

            view.addSubview(webView)

            if let url = URL(string: baseURL + requestToken!) {
                webView.load(URLRequest(url: url))
                webView.allowsBackForwardNavigationGestures = true
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        authenticationBrowserModelController?.viewWillDisappear(animated)
    }
}
