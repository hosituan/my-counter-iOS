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
    init(templates: [TemplateServer]) {
        templateViewModel.templates = templates
    }
    var body: some View {
        VStack {
            List {
                ForEach(templateViewModel.templates.indices, id: \.self) { index in
                    let template = templateViewModel.templates[index]
                    TemplateRow(teamplate: template)
                }.onDelete(perform: templateViewModel.deleteTemplate(at:))
            }
            .listSeparatorStyle(.none)
            .pullToRefresh(isShowing: $templateViewModel.isShowingRefresh) {
                templateViewModel.loadTemplate()
            }
        }.navigationBarTitle(Strings.EN.TemplateListNavTitle)
    }
    
}
