//
//  MGProgressHUD.swift
//  MGProgressHUD
//
//  Created by song on 16/7/8.
//  Copyright © 2016年 song. All rights reserved.
//

import UIKit


/**
 外部变量
 labelAlignment：title对齐方式 默认居中对齐
 detailLabelAlignment：detailText对齐方式 默认居中对齐
 labelColor:title的颜色
 */


open class MGProgressHUD: UIView {
    
    /*! title对齐方式 默认居中对齐 */
    public var labelAlignment = NSTextAlignment.center {
        didSet{
            if label != nil {
                label.textAlignment = labelAlignment
            }
        }
    }
    /*! detailText对齐方式 默认居中对齐 */
    public var detailLabelAlignment = NSTextAlignment.center {
        didSet{
            if detailLabel != nil {
                detailLabel.textAlignment = detailLabelAlignment
            }
        }
    }
    /*! title的颜色 */
    public var labelColor:UIColor? = MGColor(90, g: 90, b: 90) {
        didSet{
            if label != nil {
                label.textColor = labelColor
            }
        }
    }
    /*! detailText的颜色 */
    public var detailLabelColor:UIColor? = MGColor(102, g: 102, b: 102) {
        didSet{
            if detailLabel != nil {
                detailLabel.textColor = detailLabelColor
            }
        }
    }
    /*! title的字体大小 */
    public var labelFont = UIFont.systemFont(ofSize: 13) {
        didSet{
            if label != nil {
                label.font = labelFont
            }
        }
    }
    /*! detailText的颜色 */
    public var detailLabelFont = UIFont.systemFont(ofSize: 13){
        didSet{
            if detailLabel != nil {
                detailLabel.font = detailLabelFont
            }
        }
    }
    
    /*! title */
    public var title:String? = ""{
        didSet{
            if label != nil {
                //                label.text = title
                label.attributedText = MGAttributedString(label, text: title, lineSpacing: labelFont.pointSize/5)
            }
        }
    }
    /*! detailText */
    public var detailText:String? = ""{
        didSet{
            if detailLabel != nil {
                //                detailLabel.text = detailText
                detailLabel.attributedText = MGAttributedString(detailLabel, text: detailText, lineSpacing: detailLabelFont.pointSize/1)
            }
        }
    }
    
    /*! 设置title上面的View */
    public var  customView:UIView?{
        didSet{
            if customView != nil {
                let tapGesture = UITapGestureRecognizer(target: self, action: #selector(selectCustomViewTap))
                customView!.isUserInteractionEnabled = true
                customView!.addGestureRecognizer(tapGesture)
            }
        }
    }
    
    /*! 设置最小边距边缘值() */
    public var marginEdgeInsets:UIEdgeInsets = UIEdgeInsets(top: 13, left: 40, bottom: 10, right: 40) {
        didSet{
            layoutSubviews()
        }
    }
    
    /*! content显示出来的位置 */
    public var locationMode:MGLocationMode? = MGLocationMode.center{
        didSet{
            layoutSubviews()
        }
    }
    
    /*! content显示出来的位置 */
    public var customMode:MGCustomMode? = MGCustomMode.default{
        didSet{
            if customMode == MGCustomMode.progress {
                let view1 = CircleDataView(frame:CGRect(x: 0, y: 0, width: 50, height: 50))
                view1.backgroundColor = UIColor.clear
                self.customView = view1;
                self.contentView.addSubview(view1)
                layoutSubviews()
            }
        }
    }
    
    public var progress:CGFloat = 0 {
        didSet{
            if let circleDataView = self.customView as? CircleDataView {
                circleDataView.progress = progress*100
            }
        }
    }
    
    /*! 点击背景后的回调 */
    public var completionBlock : (() ->())!
    
    /*! 点击背景后的回调 */
    public var selectCustomViewBlock : (() ->())!
    
    /*! manualHidden为true时 调用hiddenAllhubToView时不会消失 只有手动调用hiddenHubView*/
    public var manualHidden = false
    
    public var contentView:UIView!
    public var label:UILabel!
    public var detailLabel:UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubViewsToSelf()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addSubViewsToSelf(){
        /*! 内容View */
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapSelfAction))
        isUserInteractionEnabled = true
        addGestureRecognizer(tapGesture)
        
        contentView = UIView(frame:self.bounds)
        contentView.backgroundColor = MGColor(255, g: 255, b: 255)
        contentView.layer.cornerRadius = 8
        contentView.layer.borderWidth = 0.5
        contentView.layer.borderColor = UIColor.groupTableViewBackground.cgColor
        contentView.layer.shadowOffset = CGSize(width: 1, height: 1)
        contentView.layer.shadowOpacity = 0.3
        contentView.layer.shadowColor = UIColor.black.cgColor
        addSubview(contentView)
        
        //        let bgContentView = UIVisualEffectView(effect: UIBlurEffect(style: .Light))
        //        bgContentView.alpha = 0.9
        //        bgContentView.frame = self.bounds
        //        bgContentView.autoresizingMask =  [.FlexibleWidth, .FlexibleHeight]
        //        bgContentView.layer.cornerRadius = contentView.layer.cornerRadius
        //        bgContentView.clipsToBounds = true;
        //        contentView.addSubview(bgContentView);
        
        /*! 设置自定的View */
        
        /*! titleLabel */
        label = UILabel(frame: CGRect.zero)
        contentView.addSubview(label)
        label.textAlignment = labelAlignment
        label.backgroundColor = UIColor.clear
        label.textColor = labelColor
        label.font = labelFont
        label.numberOfLines = 0;
        label.isOpaque = false;
        /*! detailLabel */
        detailLabel = UILabel(frame: CGRect.zero)
        contentView.addSubview(detailLabel)
        detailLabel.textAlignment = detailLabelAlignment
        detailLabel.backgroundColor = UIColor.clear
        detailLabel.textColor = detailLabelColor
        detailLabel.font = detailLabelFont
        detailLabel.numberOfLines = 0;
        detailLabel.isOpaque = false;
        //        detailText = "几点开始发了康师傅是否速度发货速度来看返回的数据库浪费都十分大方第三方辅导老师开发和大家快来辅导费地方但是"
    }
    
    /**
     点击背景事件回调
     */
    func  tapSelfAction(){
        if (completionBlock != nil) {
            completionBlock()
        }
    }
    
    /**
     点击Icon或customView事件的回调
     */
    func selectCustomViewTap(){
        if (selectCustomViewBlock != nil) {
            selectCustomViewBlock()
        }
    }
    
    /*! 自动识别坐标 */
    override open func layoutSubviews() {
        super.layoutSubviews()
        let maxWidth: CGFloat = bounds.width - marginEdgeInsets.left - marginEdgeInsets.right
        var contentSize:CGSize = CGSize(width: maxWidth, height:marginEdgeInsets.top)
        var  customViewWidth = CGFloat(0)
        if customView != nil {
            var customViewFitSize = CGSize(width: 0, height: 0)
            if let imageView = customView as? UIImageView
            {
                if let count = imageView.animationImages?.count, count > 0  {
                    customViewFitSize = sizeToFit(imageView.animationImages![0].size, maxWidth: maxWidth - 10)
                }
                else if let image = imageView.image
                {
                    customViewFitSize = sizeToFit(image.size, maxWidth: maxWidth - 40)
                }
                else
                {
                    customViewFitSize = sizeToFit(customView!.bounds.size, maxWidth: maxWidth - 40)
                }
            }
            else
            {
                customViewFitSize = sizeToFit(customView!.bounds.size, maxWidth: maxWidth - 40)
            }
            customViewWidth = customViewFitSize.width
            customView!.frame = CGRect(x: 0, y: marginEdgeInsets.top, width: customViewFitSize.width, height: customViewFitSize.height)
            var contentWidth =  customViewFitSize.width + 150  > maxWidth ?  maxWidth: customViewFitSize.width + 150
            contentWidth = contentWidth < maxWidth*2/3 ?  maxWidth*2/3 : contentWidth
            customView!.center = CGPoint(x: contentWidth/2, y: contentSize.height+customViewFitSize.height/2)
            contentSize = CGSize(width: contentWidth, height: contentSize.height + customViewFitSize.height)
        }
        
        if let count = title?.characters.count, count > 0 {
            let top = contentSize.height == marginEdgeInsets.top ? CGFloat(0.0):CGFloat(10.0)
            let labelFitSize = label.sizeThatFits(CGSize(width: contentSize.width - 40, height: CGFloat.greatestFiniteMagnitude))
            if labelFitSize.width  <  customViewWidth + 50 && labelFitSize.width < contentSize.width - 30 &&  detailText?.characters.count == 0{
                contentSize = CGSize(width: customViewWidth + 80, height: contentSize.height)
            }
            label.frame = CGRect(origin: CGPoint.zero, size: labelFitSize)
            label.center = CGPoint(x: contentSize.width/2, y: top + contentSize.height+labelFitSize.height/2)
            contentSize = CGSize(width: contentSize.width, height: top + contentSize.height + labelFitSize.height)
            
            if customView == nil &&  detailText?.characters.count == 0{
                contentSize = CGSize(width: labelFitSize.width + 50, height: contentSize.height)
            }
        }
        if let count = detailText?.characters.count, count > 0  {
            let top = contentSize.height == marginEdgeInsets.top ? CGFloat(0.0):CGFloat(10.0)
            let detailLabelFitSize = detailLabel.sizeThatFits(CGSize(width: contentSize.width - 40, height: CGFloat.greatestFiniteMagnitude))
            if detailLabelFitSize.width  <  customViewWidth + 50 && detailLabelFitSize.width < contentSize.width - 30{
                contentSize = CGSize(width: customViewWidth + 80, height: contentSize.height)
            }
            detailLabel.frame = CGRect(origin: CGPoint.zero, size: detailLabelFitSize)
            detailLabel.center = CGPoint(x: contentSize.width/2, y: top + contentSize.height+detailLabelFitSize.height/2 - 6)
            contentSize = CGSize(width: contentSize.width, height:  top + contentSize.height + detailLabelFitSize.height )
            if customView == nil &&  title?.characters.count == 0{
                contentSize = CGSize(width: detailLabelFitSize.width + 50, height: contentSize.height)
            }
        }
        contentSize = CGSize(width: contentSize.width, height:  contentSize.height + marginEdgeInsets.bottom )
        contentView.frame = CGRect(origin: CGPoint.zero, size: contentSize)
        switch locationMode! {
        case .top:
            contentView.center = CGPoint(x: self.bounds.width/2,y: contentSize.height/2 + 64)
            break
        case .center:
            contentView.center = CGPoint(x: self.bounds.width/2,y: self.bounds.height/2 - 20)
            break
        case .bottom:
            contentView.center = CGPoint(x: self.bounds.width/2,y: self.bounds.height - 64 - contentSize.height/2)
            break
        }
        if customView != nil {
            customView!.center = CGPoint(x: contentSize.width/2, y: customView!.center.y)
        }
        if  let count = title?.characters.count, count > 0  {
            label.center = CGPoint(x: contentSize.width/2, y: label.center.y)
        }
        if let count = detailText?.characters.count, count > 0  {
            detailLabel.center = CGPoint(x: contentSize.width/2, y: detailLabel.center.y)
        }
    }
    
    /**
     在一定范围内调整size
     - returns: <#return value description#>
     */
    func sizeToFit(_ originSize:CGSize,maxWidth:CGFloat)->CGSize{
        let  fitWidth = originSize.width > maxWidth ? maxWidth:originSize.width
        let scale = originSize.height/originSize.width
        let  fitHeight =  originSize.width > maxWidth ? maxWidth*scale:originSize.height
        return CGSize(width: fitWidth, height: fitHeight)
    }
    
    /**
     动画显示
     */
    func doAnimation(){
        //设置动画总时间
        if let imageView = customView as? UIImageView, let count = imageView.animationImages?.count, count > 0{
            imageView.animationDuration = Double(imageView.animationImages!.count) * 0.03
            //设置重复次数,0表示不重复
            imageView.animationRepeatCount=0;
            imageView.startAnimating()
        }
        
        let scaleAnimation = CAKeyframeAnimation(keyPath: "transform.scale")
        scaleAnimation.keyTimes = [0,0.35,0.55,0.60]
        scaleAnimation.values = [0.1,1.2,0.96,1]
        scaleAnimation.duration = 0.6
        contentView.layer.add(scaleAnimation, forKey: "")
        
        
        self.alpha = 0
        UIView.animate(withDuration: 0.6, animations: {
            self.alpha = 1
        }, completion: { (boo) in
        }) 
    }
    
    /**
     动画隐藏并移除
     */
    func stopAnimation(){
        if let imageView = customView as? UIImageView, let count = imageView.animationImages?.count, count > 0{
            UIView.animate(withDuration: 0.3, animations: {
                imageView.alpha = 0
            }, completion: { (boo) in
                if boo
                {
                   imageView.stopAnimating()
                }
            }) 
        }
        let scaleAnimation = CAKeyframeAnimation(keyPath: "transform.scale")
        scaleAnimation.keyTimes = [0,0.4]
        scaleAnimation.values = [1,0.8]
        scaleAnimation.duration = 0.4
        scaleAnimation.isRemovedOnCompletion = true
        contentView.layer.add(scaleAnimation, forKey: "")
        UIView.animate(withDuration: 0.3, animations: {
            self.alpha = 0
        }, completion: { (boo) in
            if boo {
                self.removeFromSuperview()
            }
        }) 
    }
    
    /**
     主要方法  用于显示View
     
     - parameter toView:       加在哪个View上
     - parameter icons:        显示的图片集 比如:["loading1","loading2","loading3"]
     - parameter message:      title显示
     - parameter messageColor: title颜色
     - parameter showBgView:   是否显示背景 默认不显示背景   背景显示就没有了边框
     - parameter detailText:    detailText显示
     - parameter detailColor:  detailText的颜色
     - parameter loationMode:  显示的位置分为上中下
     
     - returns: 返回当前对象
     */
    @discardableResult
   public class func showView(_ toView:UIView?,
                        icons:[String]?,
                        message:String?,
                        messageColor:UIColor?,
                        showBgView:Bool?,
                        detailText:String?,
                        detailColor:UIColor?,
                        loationMode:MGLocationMode?) -> MGProgressHUD?{
        /*! 如果message为空 或者toView为空  直接返回nil */
        if toView != nil
        {
            MGProgressHUD.hiddenAllhubToView(toView, animated: false, afterDelay: 0)
            var frame:CGRect = CGRect(origin: CGPoint.zero, size: toView!.bounds.size)
            if let scrollView = toView as? UIScrollView {
                frame.origin = scrollView.contentOffset
            }
            let progressView = MGProgressHUD(frame:frame)
            toView?.addSubview(progressView)
            progressView.autoresizingMask =  [.flexibleWidth, .flexibleHeight]
            /*! 显示背景色 就没有框了   没有背景色就会显示框 */
            if showBgView == true
            {
                progressView.backgroundColor = UIColor.clear
                progressView.contentView.backgroundColor = UIColor.clear
                progressView.contentView.layer.cornerRadius = 0
                progressView.contentView.layer.borderWidth = 0
                progressView.contentView.layer.shadowOffset = CGSize(width: 0, height: 0)
                progressView.contentView.layer.shadowOpacity = 1
                progressView.contentView.layer.shadowColor = UIColor.clear.cgColor
                //                progressView.labelColor = UIColor.whiteColor()
                //                progressView.detailLabelColor = UIColor.whiteColor()
            }
            if let count = icons?.count, count > 0 {
                let  imageView = UIImageView(image: UIImage(named: (icons?.first)!))
                if count > 1 {
                    var arr  = [UIImage]()
                    for name in icons! {
                        arr.append(UIImage(named: name)!)
                    }
                    imageView.animationImages = arr
                }
                imageView.backgroundColor = UIColor.clear
                progressView.contentView.addSubview(imageView)
                progressView.customView = imageView
                progressView.customView?.isUserInteractionEnabled = false
            }
            if loationMode != nil {
                progressView.locationMode = loationMode
            }
            if messageColor != nil {
                progressView.labelColor = messageColor
            }
            if detailColor != nil {
                progressView.detailLabelColor = detailColor
            }
            if message != nil {
                progressView.title = message
            }
            if detailText != nil {
                progressView.detailText = detailText
            }
            
            progressView.doAnimation()
            return progressView
        }
        return nil
    }
    /**
     主要方法  用于显示View
     
     - parameter toView:       加在哪个View上
     - parameter customView:   自定义的View  实现了完全自定义额
     - parameter message:      title显示
     - parameter messageColor: title颜色
     - parameter showBgView:   是否显示背景 默认不显示背景   背景显示就没有了边框
     - parameter detailText:    detailText显示
     - parameter detailColor:  detailText的颜色
     - parameter loationMode:  显示的位置分为上中下
     
     - returns: 返回当前对象
     */
    @discardableResult
    public class func showCustomView(_ toView:UIView?,
                              customView:UIView?,
                              message:String?,
                              messageColor:UIColor?,
                              showBgView:Bool?,
                              detailText:String?,
                              detailColor:UIColor?,
                              loationMode:MGLocationMode?) -> MGProgressHUD?{
        /*! 如果message为空 或者toView为空  直接返回nil */
        if toView != nil
        {
            MGProgressHUD.hiddenAllhubToView(toView, animated: false, afterDelay: 0)
            var frame:CGRect = CGRect(origin: CGPoint.zero, size: toView!.bounds.size)
            if let scrollView = toView as? UIScrollView {
                frame.origin = scrollView.contentOffset
            }
            let progressView = MGProgressHUD(frame:frame)
            toView?.addSubview(progressView)
            if customView != nil {
                progressView.contentView.addSubview(customView!)
                progressView.customView = customView
            }
            progressView.autoresizingMask =  [.flexibleWidth, .flexibleHeight]
            /*! 显示背景色 就没有框了   没有背景色就会显示框 */
            if showBgView == true
            {
                progressView.backgroundColor = UIColor.clear
                progressView.contentView.backgroundColor = UIColor.clear
                progressView.contentView.layer.cornerRadius = 0
                progressView.contentView.layer.borderWidth = 0
                progressView.contentView.layer.shadowOffset = CGSize(width: 0, height: 0)
                progressView.contentView.layer.shadowOpacity = 1
                progressView.contentView.layer.shadowColor = UIColor.clear.cgColor
            }
            if loationMode != nil {
                progressView.locationMode = loationMode
            }
            if messageColor != nil {
                progressView.labelColor = messageColor
            }
            if detailColor != nil {
                progressView.detailLabelColor = detailColor
            }
            if message != nil {
                progressView.title = message
            }
            if detailText != nil {
                progressView.detailText = detailText
            }
            
            progressView.doAnimation()
            return progressView
        }
        return nil
    }
    
    /**
     隐藏
     - parameter animated: 是否有动画
     */
    
    public func hideDelayed(_ animated:Bool){
        if animated {
            stopAnimation()
        }
        else{
            self.removeFromSuperview()
        }
        
    }
    
    /**
     隐藏
     - parameter animated: 是否有动画
     */
    
    public func hideAfterDelay(_ animated:Bool, afterDelay:TimeInterval){
        if afterDelay == 0 {
            hideDelayed(animated)
        }
        else{
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double((Int64)(afterDelay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: {
                self.hideDelayed(animated)
            })
        }
    }
    
    /**
     隐藏所有的弹出框
     
     - parameter toView:     在哪个页面上加的
     - parameter animated:   是否动画隐藏
     - parameter afterDelay: 几秒后隐藏
     */
    @discardableResult
    public class func hiddenAllhubToView(_ toView:UIView!,animated:Bool,afterDelay:TimeInterval)->Int{
        var count = 0
        if toView != nil {
            for view in toView.subviews {
                if let progressHUD = view as? MGProgressHUD, progressHUD.manualHidden == false {
                    progressHUD.hideAfterDelay(animated, afterDelay: afterDelay)
                    count = count + 1
                }
            }
        }
        return count
    }
    
    @discardableResult
    public class func hubViewsToView(_ toView:UIView!) -> [MGProgressHUD]
    {
        var views = [MGProgressHUD]()
        if toView != nil {
            for view in toView.subviews {
                if let progressHUD = view as? MGProgressHUD, progressHUD.manualHidden == false {
                    views.append(progressHUD)
                }
            }
        }
        return views
    }
    
    /**
     隐藏所有的弹出框
     
     - parameter toView:     在哪个页面上加的
     - parameter animated:   是否动画隐藏
     */
    @discardableResult
    public class func hiddenAllhubToView(_ toView:UIView!,animated:Bool)->Int{
        var count = 0
        if toView != nil {
            for view in toView.subviews {
                if let progressHUD = view as? MGProgressHUD, progressHUD.manualHidden == false {
                    progressHUD.hideAfterDelay(animated, afterDelay: 0)
                    count = count + 1
                }
            }
        }
        return count
    }
    
    /**
     类方法调用  隐藏单个弹出框
     
     - parameter progressHUD: 弹出框对象
     - parameter animated:    是否有动画
     - parameter afterDelay:  需不需要延迟
     */
    
    public class func hiddenHubView(_ progressHUD:MGProgressHUD!,animated:Bool,afterDelay:TimeInterval){
        progressHUD.hideAfterDelay(animated, afterDelay: afterDelay)
    }
}

extension MGProgressHUD {
    
    /**
     显示信息,不会自动隐藏 只有手动隐藏额
     
     - parameter toView:  <#toView description#>
     - parameter message: <#message description#>
     
     - returns: <#return value description#>
     */
    @discardableResult
    public class func  showMessageView(_ toView:UIView!,message:String?)->MGProgressHUD?{
        if let count = message?.characters.count, count > 0 {
            let progressView = showView(toView, icons: nil, message: message, messageColor: nil, showBgView: false, detailText: nil, detailColor: nil, loationMode: nil)
            progressView?.contentView.backgroundColor = UIColor.black.withAlphaComponent(0.65)
            progressView?.labelColor = UIColor.white
            progressView?.contentView.layer.borderColor = UIColor.black.cgColor
            return progressView
        }
        return nil
    }
    
    /**
     显示信息,不会自动隐藏 只有手动隐藏额
     
     - parameter toView:  <#toView description#>
     - parameter message: <#message description#>
     
     - returns: <#return value description#>
     */
    @discardableResult
    public class func  showProgressLoadingView(_ toView:UIView!,message:String?)->MGProgressHUD?{
        let progressView = MGProgressHUD.showView(toView, icons: nil, message: message, messageColor: nil, showBgView: false, detailText: nil, detailColor: nil, loationMode: nil)
        progressView?.customMode = MGCustomMode.progress
        return progressView
    }
    
    
    /**
     展示信息  几秒后消失
     - parameter toView:  <#toView description#>
     - parameter message: <#message description#>
     
     - returns: <#return value description#>
     */
    @discardableResult
    public class func  showTextAndHiddenView(_ toView:UIView!,message:String?)->MGProgressHUD?{
        if let count = message?.characters.count, count > 0 {
            let progressView = showView(toView, icons: nil, message: message, messageColor: nil, showBgView: false, detailText: nil, detailColor: nil, loationMode: nil)
            progressView?.contentView.backgroundColor = UIColor.black.withAlphaComponent(0.65)
            progressView?.labelColor = UIColor.white
            progressView?.contentView.layer.borderColor = UIColor.black.cgColor
            
            let lineNum = ceil(Double(message!.characters.count)/Double(12.0))
            progressView?.hideAfterDelay(true, afterDelay: 0.5*(lineNum - 1.0) + 1.5)
            return progressView
        }
        return nil
    }
    
    /**
     展示信息  几秒后消失
     - parameter toView:  toView description
     - parameter message: message description
     - parameter loationMode: message description
     
     - returns: <#return value description#>
     */
    @discardableResult
    public class func  showTextAndHiddenView(_ toView:UIView!,message:String?,loationMode:MGLocationMode?)->MGProgressHUD?{
        if let count = message?.characters.count, count > 0 {
            let progressView = showView(toView, icons: nil, message: message, messageColor: nil, showBgView: false, detailText: nil, detailColor: nil, loationMode: loationMode)
            progressView?.contentView.backgroundColor = UIColor.black.withAlphaComponent(0.65)
            progressView?.labelColor = UIColor.white
            progressView?.contentView.layer.borderColor = UIColor.black.cgColor
            
            let lineNum = ceil(Double(message!.characters.count)/Double(12.0))
            progressView?.hideAfterDelay(true, afterDelay: 0.5*(lineNum - 1.0) + 1.5)
            return progressView
        }
        return nil
    }
    
    /*! 扩展方法 */
    @discardableResult
    public class func  showView(_ toView:UIView!,
                         icon:String?,
                         message:String?,
                         messageColor:UIColor?,
                         detailText:String?,
                         detailColor:UIColor?) ->MGProgressHUD? {
        var icons = [String]()
        if let count = icon?.characters.count, count > 0 {
            icons.append(icon!)
        }
        let progressView = showView(toView, icons: icons, message: message, messageColor: messageColor, showBgView: true, detailText: detailText, detailColor: detailColor, loationMode: nil)
        progressView?.backgroundColor = UIColor.clear
        return progressView
    }
    /*! 扩展方法 */
    @discardableResult
    public class func  showView(_ toView:UIView!,
                         customView:UIView?,
                         message:String?,
                         messageColor:UIColor?,
                         detailText:String?,
                         detailColor:UIColor?) ->MGProgressHUD? {
        return showCustomView(toView, customView: customView, message: message, messageColor: messageColor, showBgView: true, detailText: detailText, detailColor: detailColor, loationMode: nil)
    }
    /*! 扩展方法 */
    @discardableResult
    public class func  showView(_ toView:UIView!,
                         icon:String?,
                         message:String?,
                         detailText:String?) ->MGProgressHUD? {
        
        return showView(toView, icon: icon, message: message, messageColor: nil, detailText: detailText, detailColor: nil)
    }
    /*! 扩展方法 */
    @discardableResult
    public class func  showFillView(_ toView:UIView!,
                               icon:String?,
                            message:String?,
                         detailText:String?) ->MGProgressHUD? {
        let progressView = showView(toView, icon: icon, message: message, messageColor: nil, detailText: detailText, detailColor: nil)
        progressView?.backgroundColor = toView.backgroundColor
        return progressView
    }
    
    @discardableResult
    public class func  showFillViewAndCallBack(_ toView:UIView!,
                                        icon:String?,
                                        message:String?,
                                        detailText:String?,
                                        callBack:@escaping ()->()) ->MGProgressHUD? {
        let progressView = showView(toView, icon: icon, message: message, messageColor: nil, detailText: detailText, detailColor: nil)
        progressView?.backgroundColor = toView.backgroundColor
        progressView?.completionBlock = callBack
        return progressView
    }
    
    /*! 扩展方法 */
    @discardableResult
    public class func  showView(_ toView:UIView!,
                         customView:UIView?,
                         message:String?,
                         detailText:String?) ->MGProgressHUD? {
        return showView(toView, customView: customView, message: message, messageColor: nil, detailText: detailText, detailColor: nil)
    }
    
    @discardableResult
    public class func showTextAndHiddenView(_ message:String?)->MGProgressHUD? {
        if let count = message?.characters.count, count > 0 {
            let progressView = showTextAndHiddenView(lastShowWindow(), message: message)
            return progressView
        }
        return nil
    }
    
    @discardableResult
    public class func hiddenHUD(_ animated:Bool)->Int{
        var count = 0
        for view in lastShowWindow().subviews {
            if let progressHUD = view as? MGProgressHUD, progressHUD.manualHidden == false {
                progressHUD.hideAfterDelay(animated, afterDelay: 0)
                count = count + 1
            }
        }
        return count
    }
    
    @discardableResult
    public class func showSuccessAndHiddenView(_ toView:UIView!,
                                        icon:String?,
                                        message:String?,
                                        detailText:String?) ->MGProgressHUD? {
        var icons = [String]()
        if let count = icon?.characters.count, count > 0 {
            icons.append(icon!)
        }
        let progressView = showView(toView, icons: icons, message: message, messageColor: nil, showBgView: false, detailText: detailText, detailColor: nil, loationMode: nil)
        progressView?.contentView.backgroundColor = UIColor.black.withAlphaComponent(0.75)
        progressView?.labelColor = UIColor.white
        progressView?.contentView.layer.borderColor = UIColor.black.cgColor
        progressView?.hideAfterDelay(true, afterDelay: 1.5)
        return progressView
    }
    
    @discardableResult
    public class func  showSuccessAndHiddenView(_ toView:UIView!,message:String?)->MGProgressHUD?{
        return self.showSuccessAndHiddenView(toView, icon: "ic_whiteCheck", message: message, detailText: nil)
    }
    
    @discardableResult
    public class func  showSuccessAndHiddenView(_ message:String?)->MGProgressHUD?{

        return self.showSuccessAndHiddenView(lastShowWindow(), icon: "ic_whiteCheck", message: message, detailText: nil)
    }
    
    @discardableResult
    public class func  showErrorAndHiddenView(_ toView:UIView!,message:String?)->MGProgressHUD?{
        return self.showSuccessAndHiddenView(toView, icon: "error", message: message, detailText: nil)
    }
    
    @discardableResult
    public class func  showErrorAndHiddenView(_ message:String?)->MGProgressHUD?{

        return self.showSuccessAndHiddenView(lastShowWindow(), icon: "error", message: message, detailText: nil)
    }
}
