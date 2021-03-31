//
//  TemplateCollectionView.swift
//  My Counter
//
//  Created by Hồ Sĩ Tuấn on 23/03/2021.
//

import Foundation
import SwiftUI

struct TemplateCollectionView: View {
    var templateList: [TemplateServer]
    var columns = 3
    var body: some View {
        ForEach(0..<((templateList.count / columns) + 1)) { index in
            HStack {
                ForEach(0..<columns) { i in
                    if index * columns + i < templateList.count {
                        TemplateCell(template: templateList[index * columns + i])
                    }
                    
                }.listRowBackground(Color.clear)
            }
            .listRowBackground(Color.clear)
        }
    }
}
