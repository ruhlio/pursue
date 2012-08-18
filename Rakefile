require 'rubygems'
require 'rspec/core/rake_task'

SPEC_PATTERN = "./test/**/*_spec.rb"

desc "Run specs"
RSpec::Core::RakeTask.new(:spec) do |task|
   task.pattern = SPEC_PATTERN
   task.rspec_opts = '--format nested --color'
end

desc "Generate code coverage"
RSpec::Core::RakeTask.new(:coverage) do |task|
   task.pattern = SPEC_PATTERN
   task.rcov = true
   task.rcov_opts = ['--exclude', 'spec']
end
