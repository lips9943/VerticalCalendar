//
//  MyLoadingVC.swift
//  For Couple
//
//  Created by 고혁준 on 6/23/25.
//
import UIKit

public class MyLoadingVC: UIViewController {
    private var spinner: UIActivityIndicatorView!
    
    public override func viewDidLoad() {
        spinner = UIActivityIndicatorView(style: .large)
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        spinner.center = view.center
        view.addSubview(spinner)
        spinner.startAnimating()
    }
    
    deinit {
        spinner = nil
    }
}
