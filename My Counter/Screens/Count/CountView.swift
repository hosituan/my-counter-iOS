//
//  CountView.swift
//  My Counter
//
//  Created by Hồ Sĩ Tuấn on 23/03/2021.
//

import Foundation
import SwiftUI
import SDWebImageSwiftUI
import Alamofire
import SocketIO

struct CountView: View {
    @Environment(\.viewController) var viewControllerHolder: ViewControllerHolder
    @State var showActionSheet = false
    @ObservedObject var countViewModel: CountViewModel
    
    init(template: Template) {
        self.countViewModel = CountViewModel(template: template)
    }
    
    var sheet: ActionSheet {
        ActionSheet(
            title: Text("Select image source"),
            buttons: [
                .default(Text(Strings.EN.TakePhoto), action: {
                    showActionSheet = false
                    showSinglePhotoPicker(.camera, modelStyle: .fullScreen)
                }),
                .default(Text(Strings.EN.SelectSinglePhoto), action: {
                    showActionSheet = false
                    showSinglePhotoPicker(.photoLibrary)
                }),
                .default(Text(Strings.EN.SelectMultiPhotos), action: {
                    showActionSheet = false
                    showMultiPhotoPicker()
                }),
                .cancel(Text(Strings.EN.CancelTitle), action: {
                    showActionSheet = false
                })
            ])
    }
    
    func showSinglePhotoPicker(_ sourceType: UIImagePickerController.SourceType = .camera, modelStyle: UIModalPresentationStyle = .pageSheet) {
        self.viewControllerHolder.value?.present(style: modelStyle) {
            ImagePickerView(sourceType: sourceType) { image in
                countViewModel.selectedImage = image
            }
            .edgesIgnoringSafeArea(.all)
        }
    }
    
    func showMultiPhotoPicker() {
        self.viewControllerHolder.value?.present(style: .pageSheet) {
            TLPhotoPickerView(currentAssets: countViewModel.selectedAsset) { (images) in
                countViewModel.selectedAsset = images
            }
            .edgesIgnoringSafeArea(.all)
        }
    }
    
    var countActionView: some View {
        VStack(alignment: .leading) {
            VStack(spacing: 0) {
                Text(countViewModel.scoreStr)
                    .foregroundColor(Color.Count.PrimaryColor)
                Slider(value: $countViewModel.score, in: 0.3...1)
                    .foregroundColor(Color.Count.PrimaryColor)
            }
            CheckView(isChecked: $countViewModel.showConfidence, title: Strings.EN.ShowConfince)
                .padding(.top)
                .isHidden(self.countViewModel.selectedImage == nil && self.countViewModel.selectedImages.count == 0)
            if countViewModel.boxResponse != nil {
                VStack(alignment: .leading) {
                    Text("\(Strings.EN.CountResultTitle)\(countViewModel.template.name ?? ""): \(countViewModel.boxResult.count)")
                        .bold()
                    Text("\(Strings.EN.SpentTime): \(countViewModel.spentTime) seconds")
                        .bold()
                    Text("\(Strings.EN.CountTime): \(countViewModel.countTime) seconds")
                        .bold()
                    HStack {
                        Text(Strings.EN.RateMessage)
                            .italic()
                            .fixedSize(horizontal: false, vertical: true)
                            .modifier(TextSize14Bold())
                        RatingView(rating: $countViewModel.rating)
                    }
                    .padding(.top, 4)
                    .padding(.bottom)
                }.padding(.top, 4)
            }
            
            Button(action: {
                countViewModel.start()
            }, label: {
                MainButtonView(title: (countViewModel.boxResponse == nil && self.countViewModel.resultImages == nil) ? Strings.EN.CountTitle: Strings.EN.ShareTitle)
            })
            .isHidden(self.countViewModel.selectedImage == nil && self.countViewModel.selectedImages.count == 0)
            .padding(.bottom)
        }
    }
    
    func imageView(image: UIImage?) -> some View {
        ZStack {
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .cornerRadius(8)
                    .padding(.bottom)
                    .onTapGesture {
                        viewControllerHolder.value?.present(style: .fullScreen) {
                            ZStack(alignment: .top) {
                                PreviewViewImage(images: [image])
                                    .edgesIgnoringSafeArea(.all)
                                Text("\(Strings.EN.CountResultTitle)\(countViewModel.template.name ?? ""): \(countViewModel.boxResponse?.result.count ?? 0)")
                                    .bold()
                                    .foregroundColor(.white)
                                    .padding(.top)
                            }
                            
                        }
                    }
            }
        }
    }
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading) {
                Text(countViewModel.template.description ?? "")
                    .bold()
                    .italic()
                    .font(.system(size: 14))
                    .padding(.bottom)
                Button(action: {
                    AppDelegate.shared().requestCameraAccess() { result in
                        if result {
                            countViewModel.showActionSheet = true
                        }
                    }
                }, label: {
                    MainButtonView(title: self.countViewModel.selectedImage == nil ? Strings.EN.SelectPhotoTitle : Strings.EN.ChangePhotoTitle)
                })
                .padding(.bottom)
                
                imageView(image: self.countViewModel.resultImage != nil ? self.countViewModel.resultImage : self.countViewModel.selectedImage)
                
                
                ImageGridView(images: countViewModel.selectedImages, assets: countViewModel.selectedAsset)

                countActionView
                    .isHidden(countViewModel.selectedImage == nil && countViewModel.selectedImages.count == 0)
                
            }
            .padding()
            .actionSheet(isPresented: $countViewModel.showActionSheet) {
                sheet
            }
            .sheet(isPresented: $countViewModel.showShareSheet) {
                ShareSheet(activityItems: [countViewModel.resultImage as Any])
            }
        }
        .background(LinearGradient(gradient: Gradient(colors: [Color.Count.TopBackgroundColor, countViewModel.backgroundColor]), startPoint: .top, endPoint: .bottom).edgesIgnoringSafeArea(.all))
        .navigationBarTitle(countViewModel.template.name ?? "")
        .onDisappear() {
            AppDelegate.shared().dismissProgressHUD()
            Color.Count.PrimaryColor = countViewModel.primaryColor
            Color.Count.PrimaryTextColor = countViewModel.textColor
        }
    }
}


//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}
