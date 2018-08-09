Pod::Spec.new do |s|
  s.name         = "BluedotPointSDK-Salesforce"
  s.version      = "1.0.0"
  s.summary      = "Salesforce integration wrapper for Bluedot Point SDK."
  s.homepage     = "https://www.bluedot.io"
  s.license      = { :type => "Copyright", :file => "LICENSE" }
  s.author = { "Bluedot Innovation" => "https://www.bluedot.io" }
  s.platform     = :ios
  s.ios.deployment_target = "10.0"

  # ――― Source Location ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  Specify the location from where the source should be retrieved.
  #  Supports git, hg, bzr, svn and HTTP.
  #

  s.source       = { :git => "http://EXAMPLE/BluedotPointSDK-Salesforce.git", :tag => "#{s.version}" }
  s.source_files  = "BDSalesforceIntegrationWrapper"
  s.requires_arc = true
  s.dependency "BluedotPointSDK"
  s.dependency "JB4ASDK"

end
