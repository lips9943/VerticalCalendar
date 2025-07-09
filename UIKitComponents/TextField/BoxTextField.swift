//
//  BoxTextField.swift
//  MyTextFields
//
//  Created by 고혁준 on 3/14/25.
//


import UIKit
internal import SnapKit
internal import Then

public protocol BoxTextFieldDelegate {
    /// 필드를 누르고 포커스가 이루어질 때 호출되고, true를 리턴한다면 DidBeginEditing을 호출합니다.
    func textFieldShouldBeginEditing(_ textField: BoxTextField) -> Bool
    func textFieldDidBeginEditing(_ textField: BoxTextField)
    /// 필드에서 포커스가 해체되었을 때 호출되고, true를 리턴한다면 DidEndEditing을 호출합니다.
    func textFieldShouldEndEditing(_ textField: BoxTextField) -> Bool
    func textFieldDidEndEditing(_ textField: BoxTextField, reason: UITextField.DidEndEditingReason)
    func textFieldDidChangeSelection(_ textField: BoxTextField)
    func textField(_ textField: BoxTextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
}

public class BoxTextField: UIView {
    // MARK: - Public Properties
    // 플레이스홀더 라벨.
    public var placeholder: String = "Title" { didSet { placeholderLabel.text = placeholder } }
    public var placeholderColor: UIColor = .black { didSet { placeholderLabel.textColor = placeholderColor } }
    public var placeholderFont: UIFont = .systemFont(ofSize: 12.5) { didSet { placeholderLabel.font = placeholderFont } }
    public var placeholderOnText: String?
    public var placeholderOnColor: UIColor = .systemGray
    public var placeholderOnFont: UIFont = .systemFont(ofSize: 9)
    
    // 텍스트 필드.
    public var text: String? { get { field.text } set { field.text = newValue } }
    public var fieldFont: UIFont = .systemFont(ofSize: 14) { didSet { field.font = fieldFont } }
    public var keyboardType: UIKeyboardType = .default { didSet { field.keyboardType = keyboardType } }
    public var fieldColor: UIColor? = .systemGray6 { didSet { field.backgroundColor = fieldColor } }
    public var leftView: UIView? { didSet { field.leftView = leftView } }
    public var leftViewMode: UITextField.ViewMode = .always { didSet { field.leftViewMode = leftViewMode } }
    public var rightView: UIView? { didSet { field.rightView = rightView } }
    public var rightViewMode: UITextField.ViewMode = .always { didSet { field.rightViewMode = rightViewMode } }
    public var cornerRadius: CGFloat = 6 { didSet { field.layer.cornerRadius = cornerRadius } }
    public var borderWidth: CGFloat = 0 { didSet { field.layer.borderWidth = borderWidth } }
    public var borderColor: UIColor = .systemGray { didSet { field.layer.borderColor = borderColor.cgColor } }
    public var fieldPlaceholder: String?
    
    // MARK: - Custom Properties
    public var delegate: BoxTextFieldDelegate?
    public var identifier: String?
    
    // MARK: - Private Properties
    private var isAnimationEnabled: Bool = false
    
    // MARK: - Title Label
    private let placeholderLabel = UILabel().then { l in
        l.numberOfLines = 0
        l.lineBreakMode = .byTruncatingTail
        l.textAlignment = .left
    }
    
    // MARK: - Date TextField
    private let field = UITextField().then { tf in
        tf.borderStyle = .roundedRect
    }
    
    
    public init(identifier: String? = nil) {
        self.identifier = identifier
        super.init(frame: .zero)
        mainConfigure()
        TFConfigure()
        titleConfigure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func mainConfigure() {
        self.backgroundColor = .clear
        self.addSubview(field)
        self.addSubview(placeholderLabel)
    }
    private func titleConfigure() {
        placeholderLabel.text = placeholder
        placeholderLabel.textColor = placeholderColor
        placeholderLabel.font = placeholderFont
        placeholderLabel.backgroundColor = .clear
        // 레이아웃
        placeholderLabel.snp.makeConstraints { make in
            make.centerY.equalTo(field)
            make.leading.equalTo(field).inset(8)
            make.trailing.equalTo(field).inset(8)
            make.height.equalTo(field)
        }
    }
    private func TFConfigure() {
        // border 설정.
        field.layer.cornerRadius = cornerRadius
        field.layer.borderColor = borderColor.cgColor
        field.layer.borderWidth = borderWidth
        
        field.font = fieldFont
        
        field.delegate = self
        field.backgroundColor = fieldColor
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 2, height: 0))
        field.leftViewMode = leftViewMode
        field.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 2, height: 0))
        field.rightViewMode = rightViewMode
        // 레이아웃
        field.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(37)
        }
        
        field.addTarget(self, action: #selector(didBegin), for: .editingDidBegin)
        field.addTarget(self, action: #selector(didEnd), for: .editingDidEnd)
    }
    
    @objc private func didBegin() {
        guard isAnimationEnabled == false else { return }
        DispatchQueue.main.async {
            self.placeholderLabel.snp.remakeConstraints { make in
                make.top.equalTo(self)
                make.bottom.equalTo(self.field.snp.top)
                make.leading.equalTo(self)
                make.trailing.equalTo(self)
                make.height.equalTo(15)
            }
            
            UIView.animate(withDuration: 0.2) {
                self.placeholderLabel.font = self.placeholderOnFont
                self.placeholderLabel.textColor = self.placeholderOnColor
                self.placeholderLabel.text = self.placeholderOnText ?? self.placeholder
                self.field.placeholder = self.fieldPlaceholder ?? self.placeholderLabel.text
                self.layoutIfNeeded()
            }
            self.isAnimationEnabled = true
        }
    }
    
    @objc private func didEnd() {
        guard isAnimationEnabled == true, field.text?.isEmpty ?? true else { return }
        DispatchQueue.main.async {
            self.placeholderLabel.snp.remakeConstraints { make in
                make.centerY.equalTo(self.field)
                make.leading.equalTo(self.field).inset(8)
                make.trailing.equalTo(self.field).inset(8)
                make.height.equalTo(self.field)
            }
            
            UIView.animate(withDuration: 0.2) {
                self.placeholderLabel.font = self.placeholderFont
                self.placeholderLabel.textColor = self.placeholderColor
                self.placeholderLabel.text = self.placeholder
                self.field.placeholder = nil
                self.layoutIfNeeded()
            }
            self.isAnimationEnabled = false
        }
    }
}

// MARK: - 텍스트 필드 델리게이트
extension BoxTextField: UITextFieldDelegate {
    public func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        guard let delegate else { return true }
        return delegate.textFieldShouldBeginEditing(self)
    }
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        // 포커스가 완료되고, 타이틀이 상단으로 이동합니다.
        guard let delegate else { return }
        delegate.textFieldDidBeginEditing(self)
    }
    public func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        guard let delegate else { return true }
        return delegate.textFieldShouldEndEditing(self)
    }
    public func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        guard let delegate else { return }
        delegate.textFieldDidEndEditing(self, reason: reason)
    }
    public func textFieldDidChangeSelection(_ textField: UITextField) {
        guard let delegate else { return }
        delegate.textFieldDidChangeSelection(self)
    }
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let delegate else { return true }
        return delegate.textField(self, shouldChangeCharactersIn: range, replacementString: string)
    }
}

// MARK: - 텍스트 필드 델리게이트 확장
public extension BoxTextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: BoxTextField) -> Bool {
        print("Begin Editing")
        return true
    }
    func textFieldDidBeginEditing(_ textField: BoxTextField) {
        print( "Did Begin Editing")
    }
    func textFieldShouldEndEditing(_ textField: BoxTextField) -> Bool {
        print("Should End Editing")
        return true
    }
    func textFieldDidEndEditing(_ textField: BoxTextField, reason: UITextField.DidEndEditingReason) {
        print("Did End Editing: Reason: \(reason)")
    }
    func textFieldDidChangeSelection(_ textField: BoxTextField) {
        print("Did Change Selection: \(textField.text ?? "")")
    }
    func textField(_ textField: BoxTextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        print("Change Characters in: Range: \(range) | String: \(string)")
        return true
    }
}

//
//#if DEBUG
//#Preview(traits: .defaultLayout, body: {
//    let tf = BoxTextField()
//    
////    tf.delegate = TestBoxTextFieldDelegate()
//    return tf
//})
//
//class TestBoxTextFieldDelegate: BoxTextFieldDelegate {
//    
//}
//#endif
//
