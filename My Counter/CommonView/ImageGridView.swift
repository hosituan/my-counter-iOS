//
//  ImageGridView.swift
//  My Counter
//
//  Created by Hồ Sĩ Tuấn on 31/05/2021.
//

import Foundation
import SwiftUI
import TLPhotoPicker

struct ImageGridView: View {
    let columns: [GridItem] = [
        GridItem(.fixed(100), spacing: 16),
        GridItem(.fixed(100), spacing: 16),
        GridItem(.fixed(100), spacing: 16)
    ]
    var images: [Image]
    var assets: [TLPHAsset] = []
    @Environment(\.viewController) var viewControllerHolder: ViewControllerHolder
    @State var uiImages: [UIImage] = []
    @State var isShowImage = false
    var body: some View {
        LazyVGrid(columns: columns) {
            ForEach(images.indices, id: \.self) { index in
                images[index]
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: UIScreen.main.bounds.width / 3.5, height: UIScreen.main.bounds.width / 3.5, alignment: .center)
                    .cornerRadius(4)
                    .clipped()
                    .onTapGesture {
                        viewControllerHolder.value?.present(style: .fullScreen) {
                            ZStack(alignment: .top) {
                                PreviewViewImage(images: uiImages, index: index)
                                    .edgesIgnoringSafeArea(.all)
                            }
                        }
                    }
            }
        }
        .onChange(of: self.assets) { (assets) in
            for asset in assets {
                uiImages.append(asset.fullResolutionImage ?? UIImage())
            }
        }
        
    }
}
