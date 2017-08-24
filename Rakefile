require 'rspec/core/rake_task'

task :default => :spec

desc "run specs"
RSpec::Core::RakeTask.new do |task|
  lab = Rake.application.original_dir
  task.pattern = "spec/*_spec.rb"
  task.verbose = false
end
