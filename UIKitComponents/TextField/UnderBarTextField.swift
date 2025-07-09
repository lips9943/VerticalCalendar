//
//  UnderBarTextField.swift
//  MyTextFields
//
//  Created by 고혁준 on 3/14/25.
//

import UIKit
internal import SnapKit
internal import Then

public protocol UnderBarTextFieldDelegate {
    /// 필드를 누르고 포커스가 이루어질 때 호출되고, true를 리턴한다면 DidBeginEditing을 호출합니다.
    func textFieldShouldBeginEditing(_ textField: UnderBarTextField) -> Bool
    func textFieldDidBeginEditing(_ textField: UnderBarTextField)
    /// 필드에서 포커스가 해체되었을 때 호출되고, true를 리턴한다면 DidEndEditing을 호출합니다.
    func textFieldShouldEndEditing(_ textField: UnderBarTextField) -> Bool
    func textFieldDidEndEditing(_ textField: UnderBarTextField, reason: UITextField.DidEndEditingReason)
    func textFieldDidChangeSelection(_ textField: UnderBarTextField)
    func textField(_ textField: UnderBarTextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
}

public class UnderBarTextField: UIView {
    // MARK: - Public Properties
    // 타이틀 라벨.
    public var title: String = "Title" { didSet { titleView.text = title } }
    public var titleColor: UIColor = .systemGray2 { didSet { titleView.textColor = titleColor } }
    public var titleFont: UIFont = .systemFont(ofSize: 12.5) { didSet { titleView.font = titleFont } }
    
    // 텍스트 필드.
    public var placeholder: String? = "placeholder" { didSet { field.placeholder = placeholder } }
    public var keyboardType: UIKeyboardType = .default { didSet { field.keyboardType = keyboardType } }
    public var text: String? { get { field.text } }
    public var fieldColor: UIColor? = .systemGray6 { didSet { field.backgroundColor = fieldColor } }
    public var leftView: UIView? { didSet { field.leftView = leftView } }
    public var leftViewMode: UITextField.ViewMode = .always { didSet { field.leftViewMode = leftViewMode } }
    public var rightView: UIView? { didSet { field.rightView = rightView } }
    public var rightViewMode: UITextField.ViewMode = .always { didSet { field.rightViewMode = rightViewMode } }
    
    // 선 view
    public var lineColor: UIColor = .systemGray4 { didSet { line.backgroundColor = lineColor } }
    
    // MARK: - Custom Properties
    public var delegate: UnderBarTextFieldDelegate?
    public var identifier: String?
    
    // MARK: - Title Label
    private let titleView = UILabel().then { l in
        l.numberOfLines = 0
        l.lineBreakMode = .byTruncatingTail
    }
    
    // MARK: - Date TextField
    private let field = UITextField().then { tf in
        tf.borderStyle = .none
        tf.backgroundColor = .clear
        tf.layer.borderColor = UIColor.clear.cgColor // 기본 border 제거
        tf.layer.borderWidth = 0
        tf.keyboardType = .numberPad
    }
    
    // MARK: - Line View
    private let line = UIView().then { v in
        v.backgroundColor = .systemGray4
    }
    
    public init(identifier: String? = nil) {
        self.identifier = identifier
        super.init(frame: .zero)
        mainConfigure()
        titleConfigure()
        TFConfigure()
        lineConfigure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func mainConfigure() {
        self.backgroundColor = .clear
        self.addSubview(titleView)
        self.addSubview(field)
        self.addSubview(line)
    }
    private func titleConfigure() {
        titleView.text = title
        titleView.textColor = titleColor
        titleView.font = titleFont
        titleView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.top.equalToSuperview().offset(5)
        }
    }
    private func TFConfigure() {
        field.delegate = self
        field.placeholder = placeholder
        field.backgroundColor = fieldColor
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        field.leftViewMode = leftViewMode
        field.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        field.rightViewMode = rightViewMode
        // 레이아웃
        field.snp.makeConstraints { make in
            make.top.equalTo(titleView.snp.bottom).offset(5)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(30)
        }
    }
    private func lineConfigure() {
        line.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(field.snp.bottom)
        }
    }
}

// MARK: - 텍스트 필드 델리게이트
extension UnderBarTextField: UITextFieldDelegate {
    public func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        guard let delegate else { return true }
        return delegate.textFieldShouldBeginEditing(self)
    }
    public func textFieldDidBeginEditing(_ textField: UITextField) {
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
extension UnderBarTextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UnderBarTextField) -> Bool {
        print("Begin Editing")
        return true
    }
    func textFieldDidBeginEditing(_ textField: UnderBarTextField) {
        print( "Did Begin Editing")
    }
    func textFieldShouldEndEditing(_ textField: UnderBarTextField) -> Bool {
        print("Should End Editing")
        return true
    }
    func textFieldDidEndEditing(_ textField: UnderBarTextField, reason: UITextField.DidEndEditingReason) {
        print("Did End Editing: Reason: \(reason)")
    }
    func textFieldDidChangeSelection(_ textField: UnderBarTextField) {
        print("Did Change Selection: \(textField.text ?? "")")
    }
    func textField(_ textField: UnderBarTextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        print("Change Characters in: Range: \(range) | String: \(string)")
        return true
    }
}


#if DEBUG
#Preview(traits: .defaultLayout, body: {
    let tf = UnderBarTextField()
    tf.delegate = TestDelegate()
    return tf
})

class TestDelegate: UnderBarTextFieldDelegate {
    
}
#endif

