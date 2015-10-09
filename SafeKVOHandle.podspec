Pod::Spec.new do |s|
  s.name         = 'SafeKVOHandle'
  s.version      = '3.0.1'
  s.summary      = 'KVO wrapper for safe using'
  s.homepage     = 'https://github.com/crazyhf/SafeKVOHandle'
  s.license      = {
      :type => 'GNU General Public License v2.0',
      :file => "LICENSE"
  }
  s.author       = { 'crazylhf' => 'crazylhf@gmail.com' }
  s.platform     = :ios, '5.0'
  s.requires_arc = true
  s.source_files = 'SafeKVOHandle/SafeKVOHandle.h', 'SafeKVOHandle/SafeKVOHandle.m', 'SafeKVOHandle/NSObject+KVOHelper.h', 'SafeKVOHandle/NSObject+KVOHelper.m'
  s.source       = { :git => 'https://github.com/crazyhf/SafeKVOHandle.git', :tag => 'v#{spec.version}' }
end
