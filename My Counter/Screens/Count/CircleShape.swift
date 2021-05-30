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
        self.rect = CGRect(x: box.x + 50, y: box.y + 50 , width: box.width - 100, height: box.height - 100)
    }
    var body: some View {
        Path { path in
            path.addEllipse(in: rect)
        }.stroke(Color.green)
        .foregroundColor(.clear)
    }
}
