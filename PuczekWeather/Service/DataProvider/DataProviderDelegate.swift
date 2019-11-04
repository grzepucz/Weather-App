//
//  DataProviderDelegate.swift
//  grzepucz.SimpleWeather
//
//  Created by Grzegorz Puczkowski on 19/10/2019.
//  Copyright © 2019 Grzegorz Puczkowski. All rights reserved.
//

import Foundation

protocol DataProviderDelegate {
    func didFinish(_ provider: DataProvider)
}
