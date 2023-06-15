//
//  ViewController.swift
//  DocumentuPickeru
//
//  Created by Glenn Posadas on 6/14/23.
//

import UIKit
import MobileCoreServices

protocol DocumentDelegate: AnyObject {
  func didPickDocument(document: Document?)
}

class Document: UIDocument {
  var data: Data?
  override func contents(forType typeName: String) throws -> Any {
    guard let data = data else { return Data() }
    return try NSKeyedArchiver.archivedData(withRootObject:data,
                                            requiringSecureCoding: true)
  }
  override func load(fromContents contents: Any, ofType typeName:
                     String?) throws {
    guard let data = contents as? Data else { return }
    self.data = data
  }
}

open class DocumentPicker: NSObject {
  private var pickerController: UIDocumentPickerViewController?
  private weak var presentationController: UIViewController?
  private weak var delegate: DocumentDelegate?
  
  private var pickedDocument: Document?
  
  init(presentationController: UIViewController, delegate: DocumentDelegate) {
    super.init()
    self.presentationController = presentationController
    self.delegate = delegate
  }
  
  func displayPicker() {
    
    /// pick movies and images
    let types = [
        kUTTypeMovie as String,
        kUTTypeVideo as String,
        kUTTypeImage as String,
        kUTTypeText as String,
        kUTTypePDF as String,
        kUTTypeGNUZipArchive as String,
        kUTTypeBzip2Archive as String,
        kUTTypeZipArchive as String,
        kUTTypeData as String,
        kUTTypeVCard as String
    ]

    pickerController = UIDocumentPickerViewController(documentTypes: [String("public.data")], in: .import)
    self.pickerController!.delegate = self
    self.pickerController!.allowsMultipleSelection = true
    self.pickerController!.modalPresentationStyle = .fullScreen
    self.presentationController?.present(self.pickerController!, animated: true)
  }
}

extension DocumentPicker: UIDocumentPickerDelegate, UINavigationControllerDelegate {
  @available(iOS 11.0, *)
  public func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
      urls.forEach { self.documentPicker(controller, didPickDocumentAt: $0) }
  }
  
  public func documentPicker(_ documentController: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
      // TODO: at least on iOS 11.3.1, DocumentPicker does not call this method until whole file will be downloaded from the cloud. This should be a bug, but in future we can check size of document before downloading it
      // FileManager.default.attributesOfItem(atPath: url.path)[NSFileSize]
      
      DispatchQueue.global().async {
          print("41242142141 didPickDocumentAt didPickDocumentAt didPickDocumentAt didPickDocumentAt didPickDocumentAt  1241242142142141")
      }
  }
  
  public func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
    controller.dismiss(animated: true, completion: nil)
  }
}

class ViewController: UIViewController, DocumentDelegate {
  func didPickDocument(document: Document?) {
    
  }
  
  
  var documentPicker: DocumentPicker!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
    
    let b = UIButton(type: .system)
    b.frame = .init(x: 0, y: 0, width: 150, height: 44)
    b.center = view.center
    b.setTitle("Attach a document", for: .normal)
    b.addTarget(self, action: #selector(openPicker), for: .touchUpInside)
    view.addSubview(b)
  }
  
  @objc
  func openPicker() {
    documentPicker = DocumentPicker(presentationController: self, delegate: self)
    documentPicker.displayPicker()
  }
}

