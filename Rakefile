require 'rake/testtask'

Rake::TestTask.new do |t|
  ENV['RACK_ENV'] = 'test'
  t.pattern = 'tests/*/*_spec.rb'
  t.warning = false
end
