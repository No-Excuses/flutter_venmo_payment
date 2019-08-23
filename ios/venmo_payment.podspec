#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#
Pod::Spec.new do |s|
  s.name             = 'venmo_payment'
  s.version          = '0.0.1'
  s.summary          = 'Flutter Plugin for sending Venmo Requests'
  s.description      = <<-DESC
Flutter Plugin for sending Venmo Requests
                       DESC
  s.homepage         = 'http://example.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Your Company' => 'email@example.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.dependency 'Flutter'
  s.dependency 'Unofficial-Venmo-iOS-SDK', '1.3.1'

  s.ios.deployment_target = '8.0'
end

