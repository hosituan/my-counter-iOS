//
//  CircleExample.swift
//  My Counter
//
//  Created by Hồ Sĩ Tuấn on 15/04/2021.
//

import Foundation
import SwiftUI

struct CircleShape: View {
    var rect: CGRect
    init(box: Box) {
        self.rect = CGRect(x: box.x - box.radius, y: box.y - box.radius, width: box.radius * 2, height: box.radius * 2)
    }
    var body: some View {
        Path { path in
            path.addEllipse(in: rect)
        }.stroke(Color.green)
        .foregroundColor(.clear)
    }
}
