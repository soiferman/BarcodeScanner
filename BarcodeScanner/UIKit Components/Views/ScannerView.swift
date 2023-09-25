//
//  ScannerView.swift
//  BarcodeScanner
//
//  Created by Max Soiferman on 25/9/23.
//

import SwiftUI

struct ScannerView: UIViewControllerRepresentable {
    
    @Binding var scannedCode: String
    @Binding var alertItem: AlertItem?
    
    func makeUIViewController(context: Context) -> ScannerViewController {
        ScannerViewController(scannerDelegate: context.coordinator)
    }
    
    func updateUIViewController(_ uiViewController: ScannerViewController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(scannerView: self)
    }
    
    final class Coordinator: NSObject, ScannerViewDelegate {
        
        private let scannerView: ScannerView
        
        init(scannerView: ScannerView) {
            self.scannerView = scannerView
        }
        
        func didFind(barcode: String) {
            scannerView.scannedCode = barcode
        }
        
        func didSurface(error: CameraError) {
            DispatchQueue.main.async { [self] in
                switch error {
                case .invalidDeviceInput:
                    scannerView.alertItem = AlertContext.invalidDeviceInput
                case .invalidScannedValue:
                    scannerView.alertItem = AlertContext.invalidScannedType
                }
            }
        }
    }
    
}

#Preview {
    ScannerView(scannedCode: .constant("test"), alertItem: .constant(.none))
}
