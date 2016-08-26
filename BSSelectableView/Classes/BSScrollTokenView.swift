//
//  BSScrollTokenView.swift
//  Pods
//
//  Created by Bartłomiej Semańczyk on 05/07/16.
//
//

public class BSScrollTokenView: UIScrollView {
    
    var multiselectableView: BSMultiSelectableView?
    
    private var tokenViews = [UIView]()
    private var placeholderLabel = UILabel()
    
    //MARK: - Class Methods
    
    //MARK: - Initialization
    
    //MARK: - Deinitialization
    
    //MARK: - Actions
    
    //MARK: - Public
    
    //MARK: - Internal
    
    func reloadData() {
        
        for subview in subviews {
            subview.removeFromSuperview()
        }
        
        tokenViews.removeAll()
        
        let count = multiselectableView?.selectedOptions.count ?? 0
        
        for index in 0..<count {
            
            if let tokenView = multiselectableView?.viewForTokenAtIndex(index) {
                
                tokenView.autoresizingMask = UIViewAutoresizing.None
                addSubview(tokenView)
                tokenViews.append(tokenView)
            }
        }
        
        invalidateIntrinsicContentSize()
        
        if count == 0 {
            
            setupPlaceholderLabel()
            addSubview(placeholderLabel)
        }
    }
    
    func setupPlaceholderLabel() {
        
        placeholderLabel.frame = CGRect(x: CGFloat(BSSelectableView.leftPaddingForPlaceholderText), y: 0, width: frame.size.width, height: multiselectableView?.lineHeight ?? 0)
        placeholderLabel.text = multiselectableView?.placeholder
        placeholderLabel.textColor = BSSelectableView.textColorForPlaceholderText
        placeholderLabel.font = BSSelectableView.fontForPlaceholderText
    }
    
    //MARK: - Private
    
    private func enumerateItemRectsUsingBlock(block: (CGRect) -> Void) {
        
        var x: CGFloat = 0
        let margin = multiselectableView?.margin ?? 0
        
        for token in tokenViews {
            
            let tokenWidth = min(CGRectGetWidth(bounds), CGRectGetWidth(token.frame))
            
            block(CGRect(x: x, y: 0, width: tokenWidth, height: token.frame.size.height))
            
            x += tokenWidth + margin
        }
    }
    
    //MARK: - Overridden
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        
        invalidateIntrinsicContentSize()
        
        var counter = 0
        
        enumerateItemRectsUsingBlock { frame in
            
            let token = self.tokenViews[counter]
            token.frame = frame
            counter += 1
        }
    }
    
    override public func intrinsicContentSize() -> CGSize {
        
        let lineHeight = multiselectableView?.lineHeight ?? 0
        
        if tokenViews.isEmpty {
            
            multiselectableView?.tokenViewHeightConstraint?.constant = lineHeight
            return CGSizeZero
        }
        
        var totalRect = CGRectNull
        
        enumerateItemRectsUsingBlock { itemRect in
            totalRect = CGRectUnion(itemRect, totalRect)
        }
        
        multiselectableView?.tokenViewHeightConstraint?.constant = max(totalRect.size.height, lineHeight)
        contentSize = CGSizeMake(totalRect.size.width, totalRect.size.height)
        
        return totalRect.size
    }
}
