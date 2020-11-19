//
//  ProfileViewController.swift
//  Talkers
//
//  Created by Natalia Kazakova on 11.09.2020.
//  Copyright © 2020 Natalia Kazakova. All rights reserved.
//

import UIKit

class ProfileViewController: BaseViewController {
  var presentationAssembly: PresentationAssemblyProtocol?
  var model: ProfileModelProtocol?

  @IBOutlet weak var profileImage: UIImageView!
  @IBOutlet weak var profilePositionTextView: UITextView!
  @IBOutlet weak var profileInitialsLabel: UILabel!
  @IBOutlet weak var GCDSaveButton: UIButton!
  @IBOutlet weak var operationSaveButton: UIButton!
  @IBOutlet weak var profileImageEditButton: UIButton!
  @IBOutlet weak var profileNameTextField: UITextField!
  @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
  @IBOutlet weak var profileEditButton: UIBarButtonItem!
  @IBOutlet weak var closeButton: UIBarButtonItem!

  // MARK: - Lifecycle

  override func viewDidLoad() {
    super.viewDidLoad()

    shapeIntoCircle(for: profileInitialsLabel)
    shapeIntoCircle(for: profileImage)

    GCDSaveButton.layer.cornerRadius = 14
    GCDSaveButton.layer.masksToBounds = true

    operationSaveButton.layer.cornerRadius = 14
    operationSaveButton.layer.masksToBounds = true

    model?.useGCDServiceType()
    loadingWillStarted()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(true)

    if let themeSettings = model?.currentThemeSettings {
      changeColorsForTheme(with: themeSettings)
    }

    NotificationCenter.default.addObserver(
      self,
      selector: #selector(textDidChangeWithNotification(_:)),
      name: UITextView.textDidChangeNotification,
      object: nil
    )

    NotificationCenter.default.addObserver(
      self,
      selector: #selector(textDidChangeWithNotification(_:)),
      name: UITextField.textDidChangeNotification,
      object: nil
    )
  }

  @objc private func textDidChangeWithNotification(_ notification: Notification) {
    isButtonsEnabled(true)
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
    model?.useGCDServiceType()
    savingWillStarted()
  }

  @IBAction func profileOperationSaveAction(_ sender: Any) {
    model?.useOperationServiceType()
    savingWillStarted()
  }

  @IBAction func profileCloseAction(_ sender: Any) {
    self.dismiss(animated: true)
  }

  @IBAction func profileEditAction(_ sender: Any) {
    editingModeDidChange(to: true)
  }
}

// MARK: - ProfileModelDelegateProtocol

extension ProfileViewController: ProfileModelDelegateProtocol {
  func profileDidLoaded(_ profile: Profile?) {
    loadingDidFinish(with: profile)
  }

  func savingDidFinish() {
    savingDidFinish(withError: false, nil)
  }

  func showError(with message: String) {
    savingDidFinish(withError: true, message)
  }
}

// MARK: - Private

private extension ProfileViewController {
  func loadingWillStarted() {
    editingModeDidChange(to: false)
    isButtonsEnabled(false)
    isServiceButtonsEnabled(false)
    progressWillShow(on: true)
    model?.loadProfile()
  }

  func loadingDidFinish(with profile: Profile?) {
    progressWillShow(on: false)
    isServiceButtonsEnabled(true)

    if let profile = profile {
      bindProfileData(for: profile)
    } else {
      bindProfileData(for: Profile(name: "", position: "", avatar: nil))
    }
  }

  func bindProfileData(for profile: Profile) {
    if let avatar = profile.avatar {
      profileInitialsLabel.isHidden = true
      profileImage.image = avatar
    } else {
      profileInitialsLabel.isHidden = false
      profileInitialsLabel.text = profile.initials
    }

    profileNameTextField.text = profile.name ?? "Your name"
    profilePositionTextView.text = profile.position ?? "Your position"
  }

  func savingWillStarted() {
    editingModeDidChange(to: false)
    isButtonsEnabled(false)
    isServiceButtonsEnabled(false)
    progressWillShow(on: true)
    model?.saveProfile(getProfileData())
  }

  func getProfileData() -> Profile {
    return Profile(
      name: profileNameTextField.text,
      position: profilePositionTextView.text,
      avatar: profileImage.image)
  }

  func savingDidFinish(withError: Bool, _ message: String?) {
    progressWillShow(on: false)
    isServiceButtonsEnabled(true)
    isButtonsEnabled(false)

    if withError {
      let alertSettings = AlertMessageSettings(
        title: "Ошибка",
        message: message,
        defaultActionTitle: "Повторить",
        defaultActionHandler: { [weak self] _ in
          self?.savingWillStarted()
        },
        cancelActionTitle: "Ок")
      showAlert(with: alertSettings)
    } else {
      showAlert(with: AlertMessageSettings(title: "Данные сохранены", message: "", defaultActionTitle: "Ок"))
      loadingWillStarted()
    }
  }

  func progressWillShow(on show: Bool) {
    show ? activityIndicator.startAnimating() : activityIndicator.stopAnimating()
    activityIndicator.isHidden = !show
  }

  func editingModeDidChange(to isEditing: Bool) {
    profileNameFieldStateChange(isEditing: isEditing)
    profilePositionFieldStateChange(isEditing: isEditing)
  }

  func profileNameFieldStateChange(isEditing: Bool) {
    profileNameTextField.isUserInteractionEnabled = isEditing
    profileNameTextField.borderStyle = isEditing ? .roundedRect : .none
    profileNameTextField.layer.borderWidth = isEditing ? 0.25 : 0.0
    profileNameTextField.layer.borderColor = isEditing ? UIColor.lightGray.cgColor : .none
    profileNameTextField.layer.cornerRadius = 5.0
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

  func isButtonsEnabled(_ isEnable: Bool) {
    operationSaveButton.isHidden = !isEnable
    GCDSaveButton.isHidden = !isEnable
  }

  func isServiceButtonsEnabled(_ isEditing: Bool) {
    profileEditButton.isEnabled = isEditing
    closeButton.isEnabled = isEditing
    profileImageEditButton.isEnabled = isEditing
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

    // todo check connection
    let loadAction = initLoadAction()
    actionSheet.addAction(loadAction)

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

  func initLoadAction() -> UIAlertAction {
    let loadAction = UIAlertAction(title: "Загрузить", style: .default) {[weak self] _ in
      if let viewController = self?.presentationAssembly?.profileImagesViewController() {
        self?.present(viewController, animated: true, completion: nil)
      }
    }
    loadAction.setValue(#imageLiteral(resourceName: "download"), forKey: "image")
    loadAction.setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAlignment")

    return loadAction
  }

  func changeColorsForTheme(with settings: ThemeSettings) {
    setNavigationBarForTheme(themeSettings: settings)

    view.backgroundColor = settings.chatBackgroundColor

    profileNameTextField.backgroundColor = settings.chatBackgroundColor
    profileNameTextField.textColor = settings.labelColor

    profilePositionTextView.backgroundColor = settings.chatBackgroundColor
    profilePositionTextView.textColor = settings.labelColor

    GCDSaveButton.titleLabel?.tintColor = settings.labelColor
    GCDSaveButton.backgroundColor = settings.outgoingColor

    operationSaveButton.titleLabel?.tintColor = settings.labelColor
    operationSaveButton.backgroundColor = settings.outgoingColor

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

  func imagePickerController(
    _ picker: UIImagePickerController,
    didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
    profileInitialsLabel.isHidden = true

    profileImage.image = info[.originalImage] as? UIImage
    profileImage.contentMode = .scaleAspectFill
    profileImage.clipsToBounds = true

    isButtonsEnabled(true)

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
