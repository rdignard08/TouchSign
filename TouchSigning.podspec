Pod::Spec.new do |s|
  s.name     = 'TouchSigning'
  s.version  = '0.1.0'
  s.license  = 'BSD'
  s.summary  = 'Get an image of a users signature.'
  s.homepage = 'https://github.com/rdignard08/TouchSign'
  s.author   = { "Ryan Dignard" => "conceptuallyflawed@gmail.com" }
  s.source   = { :git => "https://github.com/rdignard08/TouchSign.git", :tag => s.version.to_s }
  s.platform = :ios
  s.source_files = 'TouchSigning'
  s.requires_arc = true
end
