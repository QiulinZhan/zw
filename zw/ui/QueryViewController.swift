//
//  QueryViewController.swift
//  gfw
//
//  Created by Zhanqiulin on 2016/12/1.
//  Copyright © 2016年 Zhanqiulin. All rights reserved.
//

import UIKit
import WebKit

class QueryViewController: UIViewController, WKUIDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        let webview = WKWebView()
        webview.load(URLRequest(url: URL(string: "http://221.8.52.247/fdxzpapp/html/query.html")!))
        webview.scrollView.bounces = false
        webview.uiDelegate = self
        view.addSubview(webview)
        webview.snp.makeConstraints { (make) in
            make.edges.equalTo(view).inset(0)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
