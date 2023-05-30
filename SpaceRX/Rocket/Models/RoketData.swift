//
//  RoketData.swift
//  SpaceAppRx
//
//  Created by Григорий Душин on 11.05.2023.
//

import Foundation

struct Section: Hashable {
    let sectionType: SectionType
    let title: String?
    let items: [ListItem]
}

enum SectionType {
    case image
    case horizontal
    case vertical
    case button
}

enum ListItem: Hashable {
    case image(url: URL, rocketName: String)
    case verticalInfo(title: String, value: String, id: UUID = UUID())
    case horizontalInfo(title: String, value: String)
    case button
}
