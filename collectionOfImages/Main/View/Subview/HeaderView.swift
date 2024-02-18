import Foundation
import SnapKit
import UIKit

final class HeaderView: BaseView {
    private let like = UIButton()
    private let title = UILabel()
    private let textField = UITextField()
    
    private var action: EmptyClosure?
    private var changedAction: ((String) -> Void)?
    
    override func setupUI() {
        setupLike()
        setupTextField()
        setupTitle()
    }
    
    func updateUI(with isFavorite: Bool) {
        like.setImage(isFavorite ? R.image.like() : R.image.notLike(), for: .normal)
    }
}

//MARK: - Setup Action
extension HeaderView {
    func setupAction(_ action: @escaping EmptyClosure) {
        self.action = action
    }
    
    func setupChangedAction(_ action: @escaping (String) -> Void) {
        self.changedAction = action
    }
}

//MARK: - Private Extension
private extension HeaderView {
    func setupLike() {
        like.setImage(R.image.notLike(), for: .normal)
        like.addTarget(self, action: #selector(likeDidTap), for: .touchUpInside)
        addSubview(like)
        
        like.snp.makeConstraints {
            $0.right.equalToSuperview().inset(15.scaled)
            $0.centerY.equalToSuperview()
            $0.size.equalTo(35.scaled)
        }
    }
    
    func setupTextField() {
        textField.delegate = self
        textField.layer.cornerRadius = 4
        textField.layer.borderColor = R.color.gray()!.cgColor
        textField.layer.borderWidth = 1.scaled
        textField.textColor = R.color.black()
        textField.font = R.font.manropeSemiBold(size: 14.scaled)
        textField.keyboardType = .webSearch
        textField.addTarget(self, action: #selector(changed), for: .editingChanged)
        addSubview(textField)
        
        textField.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(5.scaled)
            $0.left.equalToSuperview().inset(15.scaled)
            $0.width.equalTo(200.scaled)
        }
    }
    
    func setupTitle() {
        title.text = R.string.localizable.mainScreenShowFavorites()
        title.font = R.font.manropeSemiBold(size: 18.scaled)
        title.textColor = R.color.black()
        title.textAlignment = .right
        addSubview(title)
        
        title.snp.makeConstraints {
            $0.left.equalTo(textField.snp.right).offset(10.scaled)
            $0.right.equalTo(like.snp.left).offset(-10.scaled)
            $0.centerY.equalToSuperview()
        }
    }
    
    @objc func likeDidTap() {
        action?()
    }
    
    @objc func changed() {
        guard let text = textField.text else { return }
        changedAction?(text)
    }
}

extension HeaderView: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.layer.borderColor = R.color.black()!.cgColor
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.layer.borderColor = R.color.gray()!.cgColor
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
