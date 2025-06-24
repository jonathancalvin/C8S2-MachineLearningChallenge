//
//  OCRManagerProtocol.swift
//  FenScan
//
//  Created by jonathan calvin sutrisna on 15/06/25.
//

import Foundation
import UIKit

protocol OCRManagerProtocol {
    func imageToTextHandler(image: CIImage?, frame: CGRect, completion: @escaping (String) -> Void)
}
