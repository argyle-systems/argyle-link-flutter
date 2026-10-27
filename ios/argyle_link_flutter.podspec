require "yaml"

package = YAML.load_file(File.join(__dir__, "../pubspec.yaml"))

Pod::Spec.new do |s|
  s.name             = 'argyle_link_flutter'
  s.version          = package["version"]
  s.summary          = 'A new flutter plugin project.'
  s.description      = <<-DESC
A new flutter plugin project.
                       DESC
  s.homepage         = 'http://example.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Your Company' => 'email@example.com' }
  s.source           = { :path => '.' }
  s.source_files = 'argyle_link_flutter/Sources/argyle_link_flutter/**/*'
  s.dependency 'Flutter'
  s.platform = :ios, '15.0'
  s.frameworks = 'WebKit', 'SafariServices'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'
end
