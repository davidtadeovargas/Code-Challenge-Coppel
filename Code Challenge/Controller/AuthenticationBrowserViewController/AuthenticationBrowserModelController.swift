//
//  AuthenticationBrowserModelController.swift
//  Code Challenge
//
//  Created by 230199M99806607 on 17/09/23.
//

import Foundation
import WebKit

class AuthenticationBrowserModelController : BaseViewController {
    
    var webView:WKWebView
    var requestToken: String
    
    private var onSuccess: (() -> ())?
    private var onNotSuccess: (() -> ())?
    
    
    init(uiViewController: UIViewController,
         webView:WKWebView,
         requestToken: String?,
         onSuccess: (() -> ())?,
         onNotSuccess: (() -> ())?){
        
        self.webView = webView
        self.requestToken = requestToken!
        self.onSuccess = onSuccess
        self.onNotSuccess = onNotSuccess
        super.init(uiViewController: uiViewController)
    }
    
    func viewWillDisappear(_ animated: Bool){
      
        if self.uiViewController.isMovingFromParent {
            
            webView.evaluateJavaScript("document.documentElement.outerHTML", completionHandler: { result, error in
                if let datHtml = result as? String {
                     
                    if (datHtml.contains(String(localized: "Authentication_Granted"))){
                        self.onSuccess!()
                    } else {
                        self.onNotSuccess!()
                    }
                }
            })
        }
    }
}
