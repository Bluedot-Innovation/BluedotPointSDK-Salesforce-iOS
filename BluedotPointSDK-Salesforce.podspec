Pod::Spec.new do |s|
  s.name         = "BluedotPointSDK-Salesforce"
  s.version      = "0.1.0"
  s.summary      = "Salesforce integration wrapper for Bluedot Point SDK."
  s.homepage     = "https://www.bluedot.io"
  s.license      = { :type => "Copyright", :file => "LICENSE" }
  s.author = { "Bluedot Innovation" => "https://www.bluedot.io" }
  s.platform     = :ios
  s.ios.deployment_target = "10.0"
  s.source       = { :git => "https://github.com/Bluedot-Innovation/BluedotPointSDK-Salesforce-iOS.git", :tag => s.version.to_s }
  s.source_files  = "BDSalesforceIntegrationWrapper"
  s.header_dir = "BluedotPointSDK-Salesforce"
  s.pod_target_xcconfig = { 'OTHER_LDFLAGS' => '-framework "BDPointSDK"' }
  s.vendored_frameworks = 'BDPointSDK.framework'
  s.requires_arc = true
  s.dependency "BluedotPointSDK", '~> 1.12'
  s.dependency "MarketingCloudSDK", '~> 5.2.0'
end
