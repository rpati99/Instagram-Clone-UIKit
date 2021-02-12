//
//  PostViewController.swift
//  Instagram Clone Swift
//
//  Created by Rachit Prajapati on 26/01/21.
//

import UIKit
import Firebase
import AVFoundation

class CameraViewController: UIViewController {
    
     //MARK: - Application lifecycle
    let imageController = UIImagePickerController()
    var profileImage: UIImage? = nil
    var videoUrl: URL?
    
    private let postPhotoBtn: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "add2"), for: .normal)
        button.tintColor = .twitterBlue
        button.addTarget(self, action: #selector(handlePostPhoto), for: .touchUpInside)
        button.backgroundColor = .lightGray
        button.imageView?.contentMode = .scaleAspectFill
        return button
    }()
    
    private let captionView: UITextView = {
        let cv = UITextView()
        cv.textColor = .black
        cv.font = UIFont.systemFont(ofSize: 16)
        return cv
    }()
    
    private let shareButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .black
        button.setTitle("Share", for: .normal)
        button.addTarget(self, action: #selector(handlePostProcess), for: .touchUpInside)
        
        return button
    }()
    
    

     //MARK: - Application lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        handlePost()
    }
    
     //MARK: - Application events
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
     //MARK: - Selector functions
    
    @objc func clearUI() {
        self.captionView.text = ""
        self.postPhotoBtn.setImage(UIImage(named: "add2"), for: .normal)
    }
    
    
    @objc func handlePostProcess() {
        ProgressHUD.show("Waiting..", interaction: false)
        guard let profileImage = profileImage else { return }
        guard let imageData = profileImage.jpegData(compressionQuality: 0.3) else { return  }
        guard let caption = captionView.text else { return }
        HelperService.shared.uploadDataToServer(imageData: imageData, videoUrl: self.videoUrl ,caption: caption) {
            ProgressHUD.showSuccess()
            print("DBG: Superb your post is shared")
            self.captionView.text = ""
            self.postPhotoBtn.setImage(UIImage(named: "add2"), for: .normal)
            self.tabBarController?.selectedIndex = 0 //an arbitary uivc may or may not be in tabbar
            
        }
    }
    
    @objc func handlePostPhoto() {
        imageController.delegate = self
        imageController.allowsEditing = true
        imageController.mediaTypes = ["public.image", "public.movie"]
        imageController.modalPresentationStyle = .fullScreen
        present(imageController, animated: true, completion: nil)
        
    }
    
    
    

    
   
        
    
      
    
    
    //MARK: - Helper functions
    func setupUI() {
        navigationItem.title = "Camera"
        view.addSubview(postPhotoBtn)
        postPhotoBtn.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, paddingTop: 10, paddingLeft: 8, width: 80, height: 80)
        
        view.addSubview(captionView)
        captionView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: postPhotoBtn.rightAnchor, right: view.rightAnchor, paddingTop: 10, paddingLeft: 8, paddingRight: 8, height: 100)
        
        view.addSubview(shareButton)
        shareButton.anchor(left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingLeft: 8, paddingBottom: 8, paddingRight: 8, height: 50)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Remove", style: .done, target: self, action: #selector(clearUI))

    }
    
    func handlePost() {
        if profileImage != nil {
            self.shareButton.isEnabled = true
            self.navigationItem.leftBarButtonItem?.isEnabled = true
            self.navigationItem.leftBarButtonItem?.tintColor = .black
            shareButton.backgroundColor = .black
        } else {
            self.shareButton.isEnabled = false
            self.navigationItem.leftBarButtonItem?.isEnabled = false
            self.navigationItem.leftBarButtonItem?.tintColor = .gray
            shareButton.backgroundColor = .gray
        }
    }




}
 //MARK: - PickerController delegates

extension CameraViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        print("DBG: Did finish picking image")
        print("DBG: \(info)")
        if let image = info[.editedImage] as? UIImage {
            self.profileImage = image
            guard let profileimage = profileImage else { return }
            //pass img here
            let finalImage = profileimage.withRenderingMode(.alwaysOriginal)
            postPhotoBtn.setImage(finalImage, for: .normal)
        }
        
        if let video = info[.mediaURL] as? URL {
            if let thumbnail = thumbnailForFile(video) {
                self.profileImage = thumbnail
                guard let profileimage = profileImage else { return }
                let finalImage = profileimage.withRenderingMode(.alwaysOriginal)
                postPhotoBtn.setImage(finalImage, for: .normal)
                self.videoUrl = video
            }
        }
        
        dismiss(animated: true, completion: nil)
       
    }
    
    func thumbnailForFile(_ url: URL) -> UIImage? {
        let asset = AVAsset(url: url)
        let imageGenerator = AVAssetImageGenerator(asset: asset)

        do {
            let thumbnailCGImage = try imageGenerator.copyCGImage(at: CMTimeMake(value: 1, timescale: 10), actualTime: nil)
            return UIImage(cgImage: thumbnailCGImage)
        } catch {
            print("DBG: \(error.localizedDescription)")
        }
        return nil
    }
}
