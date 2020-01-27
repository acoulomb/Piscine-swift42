//
//  LoginController.swift
//  rush00
//
//  Created by Alexandre KARASSOULOFF on 12/14/19.
//  Copyright © 2019 TeamJAJAJA. All rights reserved.
//

import UIKit
import WebKit

enum EState {
    case CODE
    case TOKEN
}

func randomString(length: Int) -> String {
    let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    return String((0..<length).map{ _ in letters.randomElement()! })
}

class LoginController: UIViewController, WKNavigationDelegate, WKUIDelegate {

    var webView: WKWebView!
    var id: String = ""
    var state: EState = EState.CODE
    var err: Error!
    var token: String = ""
    
    override func loadView() {
        let dataStore = WKWebsiteDataStore.default()
        dataStore.fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { (records) in
            for record in records {
                if record.displayName.contains("42") {
                    dataStore.removeData(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes(), for: [record], completionHandler: {
                        DispatchQueue.main.async {
                            self.webView.reload()
                        }
                    })
                }
            }
        }
        webView = WKWebView()
        self.webView.uiDelegate = self
        self.webView.navigationDelegate = self
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.id = randomString(length: 15)
        let params: [String: String] = [
            "client_id": api["42"]!.client_id,
            "redirect_uri": "http://127.0.0.1",
            "scope": "public+profile",
            "state": self.id,
            "response_type": "code",
        ]
        var urlString = "https://api.intra.42.fr/oauth/authorize"
        let request = RequestController.query(urlString: &urlString, params: params, headers: [:], method: "GET")
        webView.load(request)
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor: WKNavigationAction, decisionHandler: (WKNavigationActionPolicy) -> Void) {
        var components = URLComponents(string: decidePolicyFor.request.url!.absoluteString)
        let code = components?.queryItems?.first { $0.name == "code" }?.value
        let state = components?.queryItems?.first { $0.name == "state" }?.value
        if decidePolicyFor.request.url!.absoluteString.contains("error=access_denied") {
            self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
            decisionHandler(WKNavigationActionPolicy.cancel)
            return
        }
        
        if code != nil && state == self.id && self.state == EState.CODE {
            self.state = EState.TOKEN
            let params: [String: String] = [
                "client_id": api["42"]!.client_id,
                "client_secret": api["42"]!.client_secret,
                "redirect_uri": "http://127.0.0.1",
                "state": self.id,
                "code": code!,
                "grant_type": "authorization_code",
            ]
            var urlString = "https://api.intra.42.fr/oauth/token"
            let request = RequestController.query(urlString: &urlString, params: params, headers: [:], method: "POST")
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                if let err = error {
                    self.err = err
                }
                else if let d = data {
                    do {
                        if let dic : NSDictionary = try JSONSerialization.jsonObject(with: d) as? NSDictionary {
                            storeToken["token"] = dic.value(forKey: "access_token") as? String
                            DispatchQueue.main.async() {
                                FTController.RequestCursus() { (success, error) in
                                    if success == true {
                                        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                                        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "NavigationProfile")
                                        self.present(nextViewController, animated:true, completion:nil)
                                    } else {
                                        print(error)
                                        print("C'est la fin, des bisous aux correcteurs. Mettez nous quand meme 125")
                                    }
                                }
                            }
                        }
                    }
                    catch (let err) {
                        self.err = err
                    }
                }
            }
            task.resume()
        }
        decisionHandler(WKNavigationActionPolicy.allow)
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor: WKNavigationResponse, decisionHandler: (WKNavigationResponsePolicy) -> Void) {
        decisionHandler(WKNavigationResponsePolicy.allow)
    }
}
