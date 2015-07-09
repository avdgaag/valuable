require 'bundler/gem_tasks'
require 'rake/testtask'
require 'rdoc/task'

RDoc::Task.new :doc do |t|
  t.main = 'README.md'
  t.rdoc_files.include('README.md', 'LICENSE.txt', 'CODE_OF_CONDUCT.md', 'lib/**/*.rb')
  t.rdoc_dir = 'doc'
  t.options << '--exclude=test/.* --quiet'
end

Rake::TestTask.new(:test) do |t|
  t.libs << 'test'
  t.libs << 'lib'
  t.test_files = FileList['test/**/*_test.rb']
end

task default: :test
