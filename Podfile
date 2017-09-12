platform :ios, '8.0'
target 'GoGoTalkHD' do

inhibit_all_warnings!   #可能产生其他问题

    pod 'Masonry'
    pod 'MJRefresh'
    pod 'MJExtension'
    pod 'MBProgressHUD'
    pod 'JPush'
    
    use_frameworks!
    #和百家云的有冲突 换成ReactiveObjC
#    pod 'ReactiveCocoa', '~> 2.5.0'             # 必须加上上面的use_frameworks!

    pod 'ReactiveObjC'
    
    pod 'AFNetworking'
    pod 'FMDB'
    pod 'Reachability'
    pod 'SDWebImage'
    pod 'YYModel'

    
    pod 'Bugly'
    pod 'IQKeyboardManager'
    pod 'FSCalendar', '2.7.8'
    pod 'ZFPlayer'
    pod 'FLAnimatedImage'
    
    # 友盟 U-Share SDK
    # 集成微信(精简版0.2M)
    pod 'UMengUShare/Social/ReducedWeChat'
    
    # 集成QQ(完整版7.6M)
    pod 'UMengUShare/Social/QQ'
    
    # 集成新浪微博(精简版1M)
    pod 'UMengUShare/Social/ReducedSina'
    
    
    
    ############# 百家云 #############
    source 'https://github.com/CocoaPods/Specs.git'
    source 'https://github.com/baijia/specs.git'
    
    post_install do |installer|
        installer.pods_project.root_object.attributes["CLASSPREFIX"] = "BJL"
        installer.pods_project.root_object.attributes["ORGANIZATIONNAME"] = "Baijia Cloud"
    end
#    inhibit_all_warnings!   #可能产生其他问题   去掉pod中的警告
    pod 'BJLiveCore'
    pod 'FLEX', '~> 2.0', :configurations => ['Debug']
    ############# 百家云 #############
    
    
    
end


