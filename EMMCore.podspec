Pod::Spec.new do |s|
    s.name             = "EMMCore"
    s.version          = "0.1.0"
    s.summary          = "EMMCore 包含 EMM 核心功能"
    s.license          = "MIT"
    s.homepage         = 'git@git.yonyou.com:chenqmg/EMMCore.git'
    s.author           = { "chenqmg" => "chenqmg@yonyou.com" }
    s.source           = { :git => "git@git.yonyou.com:chenqmg/EMMCore.git", :tag => "#{s.version}" }

    s.platform = :ios
    s.ios.deployment_target = '8.0'
    s.pod_target_xcconfig = { 'OTHER_LDFLAGS' => '-lc++ -ObjC' }

    s.default_subspecs = 'Public',''

    s.subspec 'Public' do |public|
    	public.public_header_files = 'EMMCore/Public/**/*.h', 'EMMCore/Location/EMMLocationService.h'
    	public.source_files = 'EMMCore/PublicBase/**/*.{h,m}'
        public.resources = 'EMMCore/Public/**/*.{bundle,png}'
    	public.dependency 'AFNetworking', '~> 3.1.0'
    	public.dependency 'MBProgressHUD', '~> 1.0.0'
        public.dependency 'YYModel', '~> 1.0.4'
    	public.dependency 'SAMKeychain', '~> 1.5.0'
    	public.dependency 'ZipArchive', '~> 1.4.0'
        public.dependency 'Masonry', '~> 1.0.1'
        public.dependency 'RSKImageCropper', '~> 1.5.1'
  	end

  	s.subspec 'Product' do |product|  		
        product.public_header_files = 'EMMCore/product/**/*.h'
        product.source_files = 'EMMCore/ProductBase/**/*.{h,m}'
        product.resources = 'EMMCore/product/Resources/**/*.*', 'EMMCore/product/**/*.xib'                
        product.dependency 'EMMCore/Public'
        product.dependency 'EMMCore/Summer'
        product.dependency 'FMDB', '~> 2.6.2'
        product.dependency 'SDWebImage', '~> 3.8.1'
  	end
end