Pod::Spec.new do |s|
  s.name     = 'TouchSigning'
  s.version  = '1.1.0'
  s.license  = 'BSD'
  s.summary  = 'UIView to display and capture images of user touches'
  s.homepage = 'https://github.com/rdignard08/TouchSign'

  s.author   = { "Ryan Dignard" => "conceptuallyflawed@gmail.com" }
  s.source   = { :git => "https://github.com/rdignard08/TouchSign.git", :tag => s.version }
  s.requires_arc = true

  s.ios.deployment_target = '5.0'

  s.public_header_files = 'TouchSigning/*.h'
  s.source_files = 'TouchSigning'
end
