Pod::Spec.new do |s|
    s.name             = "EMMCore"
    s.version          = "0.1.1"
    s.summary          = "EMMCore 包含 EMM 核心功能"
    s.license          = "MIT"
    s.homepage         = 'git@github.com:littleMeaningTest/EMMCore.git'
    s.author           = { "chenqmg" => "chenqmg@yonyou.com" }
    s.source           = { :git => "git@github.com:littleMeaningTest/EMMCore.git", :tag => "#{s.version}" }

    s.platform = :ios
    s.ios.deployment_target = '8.0'
    
    s.public_header_files = 'EMMCore/**/*.h'
    s.source_files = 'EMMCore/**/*.{h,m}'        
    s.resources = 'EMMCore/emmcore.bundle'
    s.dependency 'AFNetworking', '~> 3.1.0'
    s.dependency 'ZipArchive', '~> 1.4.0'  
    s.dependency 'SAMKeychain', '~> 1.5.0'
    s.dependency 'Masonry', '~> 1.0.1'
    
end