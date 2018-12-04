Pod::Spec.new do |s|
  s.name         = "BluedotPointSDK-Salesforce"
  s.version      = "1.1.0"
  s.summary      = "Salesforce integration wrapper for Bluedot Point SDK."
  s.homepage     = "https://www.bluedot.io"
  s.license      = { :type => "Copyright", :file => "LICENSE" }
  s.author = { "Bluedot Innovation" => "https://www.bluedot.io" }
  s.platform     = :ios
  s.ios.deployment_target = "10.0"
  s.source       = { :git => "https://github.com/Bluedot-Innovation/BluedotPointSDK-Salesforce-iOS.git", :tag => s.version.to_s }
  s.source_files  = "BDSalesforceIntegrationWrapper"
  s.header_dir = "BluedotPointSDK-Salesforce"
  s.requires_arc = true
  s.dependency "BluedotPointSDK", '~> 1.13.0'
  s.dependency "MarketingCloudSDK", '~> 5.2.0'
end
