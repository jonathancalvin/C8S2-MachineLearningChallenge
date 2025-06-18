//
//  AlertViewModel.swift
//  FenScan
//
//  Created by jonathan calvin sutrisna on 18/06/25.
//

import Foundation
class AlertViewModel: ObservableObject {
    @Published var showAlert = false
    @Published var title = ""
    @Published var message = ""

    func show(title: String, message: String) {
        self.title = title
        self.message = message
        self.showAlert = true
    }

    func reset() {
        self.title = ""
        self.message = ""
        self.showAlert = false
    }
}
