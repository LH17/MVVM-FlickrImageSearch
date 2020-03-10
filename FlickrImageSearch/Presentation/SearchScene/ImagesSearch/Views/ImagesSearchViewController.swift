//
//  ImagesSearchViewController.swift
//  FlickrImageSearch
//
//  Created by lubaba on 3/10/20.
//  Copyright © 2020 lubaba. All rights reserved.
//

import UIKit

class ImagesSearchViewController: UIViewController, StoryboardInstantiable {

    private(set) var viewModel: ImagesSearchViewModel?
    
    static func create(with viewModel: ImagesSearchViewModel?) -> ImagesSearchViewController {
        let view = ImagesSearchViewController.instantiateViewController()
        view.viewModel = viewModel
        return view
    }
}
