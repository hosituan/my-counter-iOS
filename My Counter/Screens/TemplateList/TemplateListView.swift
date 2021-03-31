//
//  TemplateListView.swift
//  My Counter
//
//  Created by Hồ Sĩ Tuấn on 31/03/2021.
//

import Foundation
import SwiftUI

struct TemplateListView: View {
    @ObservedObject var templateViewModel = TemplateViewModel()
    var body: some View {
        VStack {
            
            List {
                ForEach(templateViewModel.templates.indices, id: \.self) { index in
                    let template = templateViewModel.templates[index]
                    
                    
                    TemplateRow(teamplate: template)
                }
            }.padding(.top)
        }.navigationBarTitle(Strings.EN.TemplateListNavTitle)
        .onAppear() {
            templateViewModel.loadTemplate()
        }
    }
}
