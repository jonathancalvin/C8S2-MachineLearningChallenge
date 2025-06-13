//
//  ExampleViewModel.swift
//  FenScan
//
//  Created by jonathan calvin sutrisna on 13/06/25.
//

import Foundation
import SwiftUI

final class ExampleViewModel: ObservableObject {
    @Published var data: String
    init(data: String) {
        self.data = data
    }
}
