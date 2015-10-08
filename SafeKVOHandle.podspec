Pod::Spec.new do |s|
  s.name         = 'SafeKVOHandle'
  s.version      = '1.0.0'
  s.summary      = 'SafeKVOHandle'
  s.homepage     = 'https://github.com/crazyhf'
  s.license      = {
      :type => 'GNU General Public License v2.0',
      :file => "LICENSE"
  }
  s.author       = { 'crazylhf' => 'crazylhf@gmail.com' }
  s.platform     = :ios, '5.0'
  s.requires_arc = true
  s.source_files = 'SafeKVOHandle/SafeKVOHandle.h', 'SafeKVOHandle/SafeKVOHandle.m'
  s.source       = { :git => 'https://github.com/crazyhf/SafeKVOHandle.git', :tag => 'release_1_0_0' }
end
