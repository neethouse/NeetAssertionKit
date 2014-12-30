Pod::Spec.new do |s|

  s.name         = "NeetAssertionKit"
  s.version      = "1.1.0"
  s.summary      = "Assertion Kit of Objective-C for NEET"

  s.description  = <<-DESC
  ## Assertion Kit of Objective-C for NEET
  DESC

  s.homepage     = "https://github.com/neethouse/NeetAssertionKit"
  s.license      = 'MIT'
  s.author       = { "covelline, LLC." => "info@covelline.com" }
  s.source       = { :git => "https://github.com/neethouse/NeetAssertionKit.git", :tag => "v1.1.0" }
  s.source_files  = 'NeetAssertionKit/*.{h,m}'
  s.requires_arc = true

end
