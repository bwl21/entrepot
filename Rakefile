require "bundler/gem_tasks"
require 'rspec/core/rake_task'
require 'rake/clean'

desc "Run specs"
RSpec::Core::RakeTask.new(:spec, :focus) do |t, args|
  t.pattern = "./spec/**/*_spec.rb" # don't need this, it's default.
  if args[:focus] then
    usetags="--tag #{args[:focus]}"
  else
    usetags="--tag ~exp"
  end
  t.rspec_opts = [usetags,
                  " -fd -fd --out ./testresults/testresults.log -fh --out ./testresults/testresults.html"]
  # Put spec opts in a file named .rspec in root
end