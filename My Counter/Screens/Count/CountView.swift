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
                    countViewModel.sourceType = .camera
                    showImagePicker()
                }),
                .default(Text(Strings.EN.SelectFromLibrary), action: {
                    showActionSheet = false
                    countViewModel.sourceType = .photoLibrary
                    showImagePicker()
                }),
                .cancel(Text(Strings.EN.CancelTitle), action: {
                    showActionSheet = false
                })
            ])
    }
    
    func showImagePicker() {
        self.viewControllerHolder.value?.present(style: .fullScreen)  {
            ImagePickerView(sourceType: countViewModel.sourceType) { image in
                self.countViewModel.selectedImage = image
            }
            .edgesIgnoringSafeArea(.all)
        }
    }
    
    var countActionView: some View {
        VStack(alignment: .leading) {
            CheckView(isChecked: $countViewModel.showConfidence, title: Strings.EN.ShowConfince)
                .padding(.top)
                .isHidden(self.countViewModel.selectedImage == nil)
            if countViewModel.boxResponse != nil {
                VStack(alignment: .leading) {
                    Text("\(Strings.EN.CountResultTitle)\(countViewModel.template.name ?? ""): \(countViewModel.boxResponse?.result.count ?? 0)")
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
                MainButtonView(title: countViewModel.boxResponse == nil ? Strings.EN.CountTitle: Strings.EN.SaveTitle)
            })
            .isHidden(self.countViewModel.selectedImage == nil)
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
                                PreviewViewImage(image: image)
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
                            showActionSheet = true
                        }
                    }
                }, label: {
                    MainButtonView(title: self.countViewModel.selectedImage == nil ? Strings.EN.SelectPhotoTitle : Strings.EN.ChangePhotoTitle)
                })
                .padding(.bottom)
                
                imageView(image: self.countViewModel.resultImage != nil ? self.countViewModel.resultImage : self.countViewModel.selectedImage)
                countActionView
                    .isHidden(countViewModel.selectedImage == nil)
                
            }
            .padding()
            .actionSheet(isPresented: $showActionSheet) {
                sheet
            }
        }
        .background(LinearGradient(gradient: Gradient(colors: [Color.Count.TopBackgroundColor, Color.Count.BackgroundColor]), startPoint: .top, endPoint: .bottom).edgesIgnoringSafeArea(.all))
        .navigationBarTitle(countViewModel.template.name ?? "")
        .onDisappear() {
            AppDelegate.shared().dismissProgressHUD()
        }
    }
}


//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}
