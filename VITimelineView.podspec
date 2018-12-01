Pod::Spec.new do |s|

    s.name = 'VITimelineView'
    s.version = '0.1'
    s.summary = 'VITimelineView can represent any time base things. Made with fully customizable & extendable.'

    s.license = { :type => "MIT", :file => "LICENSE" }

    s.homepage = 'https://github.com/VideoFlint/VITimelineView'

    s.author = { 'Vito' => 'vvitozhang@gmail.com' }

    s.platform = :ios, '9.0'

    s.source = { :git => 'https://github.com/VideoFlint/VIPlayer.git', :tag => s.version.to_s }
    s.source_files = ['VITimelineViewDemo/Sources/**/*.{h,m}']

    s.requires_arc = true

end

