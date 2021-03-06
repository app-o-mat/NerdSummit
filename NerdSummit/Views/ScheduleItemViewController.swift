//
//  ScheduleItemViewController.swift
//  NerdSummit
//
//  Created by Louis Franco on 2/26/17.
//  Copyright © 2017 Lou Franco. All rights reserved.
//

import UIKit
import WebKit

class ScheduleItemViewController: UIViewController, WKNavigationDelegate {

    let config = WKWebViewConfiguration()
    var webView: WKWebView! = nil

    // This needs to be set in prepareForSegue of the presenter
    var item: ScheduleItem!

    override func viewDidLoad() {
        config.dataDetectorTypes = [.link]
        webView = WKWebView(frame: .zero, configuration: config)
        webView.navigationDelegate = self

        super.viewDidLoad()

        super.view.addSubview(webView)

        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        webView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        webView.leadingAnchor.constraint(equalTo: super.view.leadingAnchor).isActive = true
        webView.trailingAnchor.constraint(equalTo: super.view.trailingAnchor).isActive = true

        let text = item.sessionText

        self.title = "\(item.room) @ \(Schedule.formatTime(time: item.startTime))"

        webView.scrollView.isScrollEnabled = true
        let style = "<style>body { font-family: -apple-system, BlinkMacSystemFont, sans-serif; font-size: 30pt; margin: 0 20px 0 20px;} .track { color: gray; } h1, h2, h4 { text-align: center; } </style>"
        let track = (item.type != "") ? "<h4 class=\"track\">Track: \(item.type)</h4>" : ""
        let html = "<html><head><meta charset=\"utf-8\">\(style)</head><body><h1>\(item.session)</h1><h2>\(item.speaker)</h2><span>\(text)</span></body>\(track)</html>"
        webView.loadHTMLString(html, baseURL: nil)

        if let _ = item.joinLink {
            let btn = UIBarButtonItem(title: "Join", style: .plain, target: self, action: #selector(join(sender:)))
            self.navigationItem.rightBarButtonItems = [btn]
        }
    }

    @objc func join(sender: Any) {
        guard let joinLink = item.joinLink else {
            return
        }
        UIApplication.shared.open(joinLink, options: [:], completionHandler: nil)
    }

    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if navigationAction.navigationType == .linkActivated, let url = navigationAction.request.url {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
            decisionHandler(.cancel)
            return
        }
        decisionHandler(.allow)
    }


}
