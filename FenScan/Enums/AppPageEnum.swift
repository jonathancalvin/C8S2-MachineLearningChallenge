//
//  AppPage.swift
//  FenScan
//
//  Created by jonathan calvin sutrisna on 28/06/25.
//


enum AppPageEnum: Hashable, CaseIterable {
    case landing
    case guide
    case scan
    
    var index: Int {
        switch self {
        case .landing:
            0
        case .guide:
            1
        case .scan:
            2
        }
    }
}
