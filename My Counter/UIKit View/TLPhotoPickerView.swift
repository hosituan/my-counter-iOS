//
//  TLPhotoPickerView.swift
//  My Counter
//
//  Created by Hồ Sĩ Tuấn on 31/05/2021.
//

import Foundation
import SwiftUI
import TLPhotoPicker

public struct TLPhotoPickerView: UIViewControllerRepresentable {
    @Environment(\.presentationMode) private var presentationMode
    @Environment(\.viewController) var viewControllerHolder: ViewControllerHolder
    var currentAssets: [TLPHAsset] {
        didSet {
            selectedAssets(currentAssets)
        }
    }
    let selectedAssets: ([TLPHAsset]) -> Void
    
    public func makeCoordinator() -> Coordinator {
        Coordinator(
            onDismiss: {
                self.presentationMode.wrappedValue.dismiss()
                self.viewControllerHolder.value?.dismiss(animated: true, completion: nil)
            },
            selectedAssets: self.selectedAssets
        )
    }
    
    public func makeUIViewController(context: Context) -> some UIViewController {
        let viewController = TLPhotosPickerViewController()
        viewController.delegate = context.coordinator
        viewController.selectedAssets = self.currentAssets
        return viewController
    }
    
    public func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
    }
    
    final public class Coordinator: NSObject, TLPhotosPickerViewControllerDelegate {
        var selectedAssets: ([TLPHAsset]) -> Void
        private let onDismiss: () -> Void
        
        init(onDismiss: @escaping () -> Void, selectedAssets: @escaping ([TLPHAsset]) -> Void) {
            self.onDismiss = onDismiss
            self.selectedAssets = selectedAssets
        }
        
        public func shouldDismissPhotoPicker(withTLPHAssets: [TLPHAsset]) -> Bool {
            self.selectedAssets(withTLPHAssets)
            return true
        }
        
        public func photoPickerDidCancel() {
            self.onDismiss()
        }
        public func dismissComplete() {
            self.onDismiss()
        }
        
    }
}
