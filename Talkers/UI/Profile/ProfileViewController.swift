//
//  ProfileViewController.swift
//  Talkers
//
//  Created by Natalia Kazakova on 11.09.2020.
//  Copyright © 2020 Natalia Kazakova. All rights reserved.
//

import UIKit

class ProfileViewController: BaseViewController {
  enum SavingMethod {
    case gcd, operation
  }
  @IBOutlet weak var profileImage: UIImageView!
  @IBOutlet weak var profilePositionTextView: UITextView!
  @IBOutlet weak var profileInitialsLabel: UILabel!
  @IBOutlet weak var GCDSaveButton: UIButton!
  @IBOutlet weak var operationSaveButton: UIButton!
  @IBOutlet weak var profileImageEditButton: UIButton!
  @IBOutlet weak var profileNameTextField: UITextField!
  @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

  var userProfile: UserProfile?

  // MARK: - Lifecycle

  override func viewDidLoad() {
    super.viewDidLoad()

    shapeIntoCircle(for: profileInitialsLabel)
    shapeIntoCircle(for: profileImage)

    GCDSaveButton.layer.cornerRadius = 14
    GCDSaveButton.layer.masksToBounds = true

    operationSaveButton.layer.cornerRadius = 14
    operationSaveButton.layer.masksToBounds = true
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(true)

    changeColorsForTheme(with: ThemeManager.shared.themeSettings)
  }

  // MARK: - IBActions

  @IBAction func profileImageEditAction(_ sender: Any) {
    if !isImageSourcesAvailable() {
      let alertSettings = AlertMessageSettings(
        title: "Ошибка",
        message: "Нет доступных источников изображения",
        defaultActionTitle: "Ок")
      showAlert(with: alertSettings)
      return
    }

    let actionSheet = initActionSheet()
    present(actionSheet, animated: true)
  }

  @IBAction func profileGSDSaveAction(_ sender: Any) {
    savingWillStarted(withMethod: .gcd)
  }

  @IBAction func profileOperationSaveAction(_ sender: Any) {
    savingWillStarted(withMethod: .operation)
  }

  @IBAction func profileCloseAction(_ sender: Any) {
    self.dismiss(animated: true)
  }

  @IBAction func profileEditAction(_ sender: Any) {
    editingModeDidChange(to: true)
  }
}

// MARK: - Private

private extension ProfileViewController {
  func saveUserProfile(withMethod method: SavingMethod) {
    guard let profile = self.userProfile else { return }

    switch method {
    case .operation:
      FileStorageManager.shared.saveToFileWithOperation(profile: profile) {[weak self] error in
        DispatchQueue.main.async {
          self?.savingDidFinish(for: method, withError: error)
        }
      }
    case .gcd:
      FileStorageManager.shared.saveToFileWithGCD(profile: profile) {[weak self] error in
        DispatchQueue.main.async {
          self?.savingDidFinish(for: method, withError: error)
        }
      }
    }
  }

  func loadUserProfile() {
    self.userProfile = UserProfile(
      name: "Natalia Kazakova",
      position: "UX/UI designer, web-designer Moscow, Russia",
      avatar: UIImage())
  }

  func savingWillStarted(withMethod method: SavingMethod) {
    editingModeDidChange(to: false)
    progressWillShow(on: true)
    saveUserProfile(withMethod: method)
  }

  func savingDidFinish(for method: SavingMethod, withError: Bool) {
    progressWillShow(on: false)

    if withError {
      let alertSettings = AlertMessageSettings(
        title: "Ошибка",
        message: "Не удалось сохранить данные",
        defaultActionTitle: "Повторить",
        defaultActionHandler: { [weak self] in
          self?.savingWillStarted(withMethod: method)
        },
        cancelActionTitle: "Ок")
      showAlert(with: alertSettings)
    } else {
      showAlert(with: AlertMessageSettings(title: "Данные сохранены", message: "", defaultActionTitle: "Ок"))
    }
  }

  func progressWillShow(on show: Bool) {
    show ? activityIndicator.startAnimating() : activityIndicator.stopAnimating()
    activityIndicator.isHidden = !show
  }

  func editingModeDidChange(to isEditing: Bool) {
    profileNameFieldStateChange(isEditing: isEditing)
    profilePositionFieldStateChange(isEditing: isEditing)
    saveButtonsStateChange(isEditing: isEditing)
  }

  func profileNameFieldStateChange(isEditing: Bool) {
    profileNameTextField.isUserInteractionEnabled = isEditing
    profileNameTextField.borderStyle = isEditing ? .roundedRect : .none
    if isEditing {
      profileNameTextField.becomeFirstResponder()
    }
  }

  func profilePositionFieldStateChange(isEditing: Bool) {
    profilePositionTextView.isUserInteractionEnabled = isEditing
    profilePositionTextView.layer.borderWidth = isEditing ? 0.25 : 0.0
    profilePositionTextView.layer.borderColor = isEditing ? UIColor.lightGray.cgColor : .none
    profilePositionTextView.layer.cornerRadius = 5.0
  }

  func saveButtonsStateChange(isEditing: Bool) {
    operationSaveButton.isEnabled = isEditing
    GCDSaveButton.isEnabled = isEditing
  }

  func shapeIntoCircle(for view: UIView) {
    view.layer.cornerRadius = view.bounds.width / 2
    view.layer.masksToBounds = true
  }

  func isImageSourcesAvailable() -> Bool {
    return UIImagePickerController.isSourceTypeAvailable(.camera) ||
      UIImagePickerController.isSourceTypeAvailable(.photoLibrary)
  }

  func initActionSheet() -> UIAlertController {
    let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

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

  func initCameraAction() -> UIAlertAction {
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
    profileNameTextField.textColor = settings.labelColor
    profilePositionTextView.textColor = settings.labelColor
    GCDSaveButton.titleLabel?.tintColor = settings.labelColor
    GCDSaveButton.backgroundColor = settings.incomingColor
    operationSaveButton.titleLabel?.tintColor = settings.labelColor
    operationSaveButton.backgroundColor = settings.incomingColor
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

  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
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
    let navigationVC = storyboard.instantiateInitialViewController() as? UINavigationController
    let profileVC = navigationVC?.topViewController as? ProfileViewController
    profileVC?.loadUserProfile()

    return navigationVC
  }
}
