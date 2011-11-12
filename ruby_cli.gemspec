Gem::Specification.new do |s|
	s.name = 'ruby_cli'
	s.version = '0.0.1'
	s.executables = ['hello_world']
	s.date = '2011-11-11'
	s.summary = "A command line application library"
	s.description = "Factors out code needed to create Ruby command line applications"
	s.authors = ["Martin Velez"]
	s.email = 'mvelez999@gmail.com'
	s.files = ["lib/ruby_cli.rb", "README.rdoc", "bin/hello_world", "test/test_ruby_cli.rb", "Rakefile"]
	s.homepage = 'http://github.com/martinvelez/ruby_cli'
	s.require_paths = ["lib"]
end
