//
//  TemplateCollectionView.swift
//  My Counter
//
//  Created by Hồ Sĩ Tuấn on 23/03/2021.
//

import Foundation
import SwiftUI

struct TemplateCollectionView: View {
    var templateList: [Template]
    var columns = 3
    @Binding var selection: Int
    @Binding var didTap: Bool
    var body: some View {
        VStack {
            ForEach(templateList.indices, id: \.self) { index in
                HStack {
                    ForEach(0..<columns) { i in
                        if index * columns + i < templateList.count {
                            Button(action: {
                                selection  = index * columns + i
                                didTap = true
                            }) {
                                TemplateCell(template: templateList[index * columns + i])
                                    .buttonStyle(PlainButtonStyle())
                            }
                        }

                    }.listRowBackground(Color.clear)
                }
                .listRowBackground(Color.clear)
            }
            Spacer()
        }
    }
}
