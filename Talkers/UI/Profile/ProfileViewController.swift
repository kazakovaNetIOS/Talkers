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
    
    // MARK: - Init
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        // Вызывает ошибку Unexpectedly found nil while implicitly unwrapping,
        // так как в этот момент еще не отработал метод loadView(), который
        // создает представление для контроллера
        // print("Frame profileSaveButton on \(#function): \(profileSaveButton.frame)")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // view еще не получило актуальных размеров, изменять их в этом методе нельзя
        print("Frame profileSaveButton on \(#function): \(profileSaveButton.frame)")
        
        shapeIntoCircle(for: profileInitialsLabel)
        shapeIntoCircle(for: profileImage)
        
        profileSaveButton.layer.cornerRadius = 14
        profileSaveButton.layer.masksToBounds = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // view отображено на экране, встроено в иерархию представлений и имеет
        // актуальные размеры, которыми можно оперировать
        print("Frame profileSaveButton on \(#function): \(profileSaveButton.frame)")
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
    
    // MARK: - Private
    
    private func shapeIntoCircle(for view: UIView) {
        view.layer.cornerRadius = view.bounds.width / 2
        view.layer.masksToBounds = true
    }
    
    private func isImageSourcesAvailable() -> Bool {
        return UIImagePickerController.isSourceTypeAvailable(.camera) ||
            UIImagePickerController.isSourceTypeAvailable(.photoLibrary)
    }
    
    private func showError() {
        let alert = UIAlertController(title: "Ошибка", message: "Нет доступных источников изображения", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        
        present(alert, animated: true)
    }
    
    private func initActionSheet() -> UIAlertController {
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
    
    private func initCameraAction() -> UIAlertAction{
        let cameraAction = UIAlertAction(title: "Сделать фото", style: .default) { _ in
            self.chooseImagePicker(source: .camera)
        }
        cameraAction.setValue(#imageLiteral(resourceName: "camera"), forKey: "image")
        cameraAction.setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAlignment")
        
        return cameraAction
    }
    
    private func initPhotoAction() -> UIAlertAction {
        let photoAction = UIAlertAction(title: "Установить из галереи", style: .default) { _ in
            self.chooseImagePicker(source: .photoLibrary)
        }
        photoAction.setValue(#imageLiteral(resourceName: "image"), forKey: "image")
        photoAction.setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAlignment")
        
        return photoAction
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
    static func storyboardInstance() -> ProfileViewController? {
        let storyboard = UIStoryboard(name: String(describing: self), bundle: nil)
        return storyboard.instantiateInitialViewController() as? ProfileViewController
    }
}
