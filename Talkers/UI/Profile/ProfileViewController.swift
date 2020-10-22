//
//  ProfileViewController.swift
//  Talkers
//
//  Created by Natalia Kazakova on 11.09.2020.
//  Copyright © 2020 Natalia Kazakova. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var profileNameLabel: UILabel!
    @IBOutlet weak var profilePositionLabel: UILabel!
    @IBOutlet weak var profileInitialsLabel: UILabel!
    @IBOutlet weak var profileSaveButton: UIButton!
    @IBOutlet weak var profileImageEditButton: UIButton!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()        
        
        shapeIntoCircle(for: profileInitialsLabel)
        shapeIntoCircle(for: profileImage)
        
        profileSaveButton.layer.cornerRadius = 14
        profileSaveButton.layer.masksToBounds = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        changeColorsForTheme(with: ThemeManager.shared.themeSettings)
    }
    
    // MARK: - IBActions
    
    @IBAction func profileImageEditAction(_ sender: Any) {
        if !isImageSourcesAvailable() {
            showError()
            return
        }
        
        let actionSheet = initActionSheet()
        present(actionSheet, animated: true)
    }
    
    @IBAction func profileSaveAction(_ sender: Any) {
        // TODO: - Stub
    }
    
    @IBAction func profileCloseAction(_ sender: Any) {
        self.dismiss(animated: true)
    }
}

// MARK: - Private

private extension ProfileViewController {
    func shapeIntoCircle(for view: UIView) {
        view.layer.cornerRadius = view.bounds.width / 2
        view.layer.masksToBounds = true
    }
    
    func isImageSourcesAvailable() -> Bool {
        return UIImagePickerController.isSourceTypeAvailable(.camera) ||
            UIImagePickerController.isSourceTypeAvailable(.photoLibrary)
    }
    
    func showError() {
        let alert = UIAlertController(title: "Ошибка", message: "Нет доступных источников изображения", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        
        present(alert, animated: true)
    }
    
    func initActionSheet() -> UIAlertController {
        let actionSheet = UIAlertController(title: nil,
                                            message: nil,
                                            preferredStyle: .actionSheet)
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let camera = initCameraAction()
            actionSheet.addAction(camera)
        }
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let photo = initPhotoAction()
            actionSheet.addAction(photo)
        }
        
        let cancel = UIAlertAction(title: "Отменить", style: .cancel)
        actionSheet.addAction(cancel)
        
        actionSheet.pruneNegativeWidthConstraints()
        
        return actionSheet
    }
    
    func initCameraAction() -> UIAlertAction{
        let cameraAction = UIAlertAction(title: "Сделать фото", style: .default) { _ in
            self.chooseImagePicker(source: .camera)
        }
        cameraAction.setValue(#imageLiteral(resourceName: "camera"), forKey: "image")
        cameraAction.setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAlignment")
        
        return cameraAction
    }
    
    func initPhotoAction() -> UIAlertAction {
        let photoAction = UIAlertAction(title: "Установить из галереи", style: .default) { _ in
            self.chooseImagePicker(source: .photoLibrary)
        }
        photoAction.setValue(#imageLiteral(resourceName: "image"), forKey: "image")
        photoAction.setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAlignment")
        
        return photoAction
    }
    
    func changeColorsForTheme(with settings: ThemeSettings) {
        setNavigationBarForTheme()
        
        view.backgroundColor = settings.chatBackgroundColor
        profileNameLabel.textColor = settings.labelColor
        profilePositionLabel.textColor = settings.labelColor
        profileSaveButton.titleLabel?.tintColor = settings.labelColor
        profileSaveButton.backgroundColor = settings.incomingColor
        profileImageEditButton.titleLabel?.tintColor = settings.labelColor
    }
}

// MARK: - Work with image

extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func chooseImagePicker(source: UIImagePickerController.SourceType) {
        
        guard UIImagePickerController.isSourceTypeAvailable(source) else {
            return
        }
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = source
        
        present(imagePicker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        profileInitialsLabel.isHidden = true
        
        profileImage.image = info[.originalImage] as? UIImage
        profileImage.contentMode = .scaleAspectFill
        profileImage.clipsToBounds = true
        
        dismiss(animated: true)
    }
}

// MARK: - UIAlertController etension

extension UIAlertController {
    func pruneNegativeWidthConstraints() {
        // FIX error about negative constraint for ActionSheet
        for subView in self.view.subviews {
            for constraint in subView.constraints where constraint.debugDescription.contains("width == - 16") {
                subView.removeConstraint(constraint)
            }
        }
    }
}

// MARK: - Instantiation from storybord

extension ProfileViewController {
    static func storyboardInstance() -> UINavigationController? {
        let storyboard = UIStoryboard(name: String(describing: self), bundle: nil)
        return storyboard.instantiateInitialViewController() as? UINavigationController
    }
}
