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
    
    init(template: TemplateServer) {
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
               
                
                if let url = URL(string: countViewModel.countResponse?.url ?? "") {
                    VStack(alignment: .leading) {
                        WebImage(url: url)
                            .resizable()
                            .placeholder(content: {
                                Image(uiImage: countViewModel.selectedImage!)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .cornerRadius(8)
                            })

                            .aspectRatio(contentMode: .fill)
                            .cornerRadius(8)
                            .padding(.bottom)
                            .onTapGesture {
                                viewControllerHolder.value?.present(style: .fullScreen) {
                                    ZStack(alignment: .top) {
                                        PreviewViewImage(link: countViewModel.countResponse?.url ?? "")
                                            .edgesIgnoringSafeArea(.all)
                                        Text("\(Strings.EN.CountResultTitle)\(countViewModel.countResponse?.name ?? ""): \(countViewModel.countResponse?.count ?? 0)")
                                            .bold()
                                            .foregroundColor(.white)
                                            .padding(.top)
                                    }
                                    
                                }
                            }
 
                        Text("\(Strings.EN.CountResultTitle)\(countViewModel.template.name ?? ""): \(countViewModel.countResponse?.count ?? 0)")
                            .bold()
                        Text("\(Strings.EN.SpentTime): \(countViewModel.spentTime) seconds")
                            .bold()
                        Text("\(Strings.EN.CountTime): \(countViewModel.countTime) seconds")
                            .bold()
                        HStack {
                            Text(Strings.EN.RateMessage)
                                .italic()
                                .modifier(TextSize12Bold())
                            RatingView(rating: $countViewModel.rating)
                        }
                        .padding(.top)
        
                    }
                }
                else if let img = self.countViewModel.selectedImage {
                    ZStack {
                        Image(uiImage: img)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .cornerRadius(8)
                            .padding(.bottom)
                    }
                }
                
                
                CheckView(isChecked: $countViewModel.showConfidence, title: Strings.EN.ShowConfince)
                    .padding(.top)
                    .isHidden(self.countViewModel.selectedImage == nil)
                CheckView(isChecked: $countViewModel.isAdvanced, title: Strings.EN.AdvancedMethod)
                    .padding(.top, 4)
                    .isHidden(self.countViewModel.selectedImage == nil)
                
                Button(action: {
                    countViewModel.start()
                    
                }, label: {
                    MainButtonView(title: countViewModel.countResponse == nil ? Strings.EN.CountTitle: Strings.EN.SaveTitle)
                })
                .isHidden(self.countViewModel.selectedImage == nil)
                .padding(.bottom)
            }
            .padding()
            .actionSheet(isPresented: $showActionSheet) {
                sheet
            }
        }
        .onAppear {
            
        }
        .navigationBarTitle(countViewModel.template.name ?? "")
        .onDisappear() {
//            countViewModel.selectedImage = nil
//            countViewModel.countResponse = nil
//            AppDelegate.shared().dismissProgressHUD()
        }
    }
}




//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}
