//
//  Investigation.swift
//  Bashneft
//
//  Created by Руслан Ишмухаметов on 22.03.2023.
//

import Foundation

struct Investigation: Identifiable, Hashable {
    var id: String = UUID().uuidString
    var name: String
    var imageName: String
    var fullName: String
    var rating: Int
    var count: Int
}

var sampleInvestigations: [Investigation] = [
    .init(name: "КВД", imageName: "well1", fullName: "Кривая восстановления давления", rating: 5, count: 381),
    .init(name: "КВУ", imageName: "well2", fullName: "Кривая восстановления уровня", rating: 4, count: 1697),
    .init(name: "КПД", imageName: "well3", fullName: "Кривая падения давления", rating: 5, count: 2342),
    .init(name: "ИК", imageName: "well4", fullName: "Индикаторная кривая", rating: 3, count: 85),

]
