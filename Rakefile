require "rspec/core/rake_task"

RSpec::Core::RakeTask.new(:spec)

task default: :spec

namespace :assets do
  desc "Build the Tailwind 4 stylesheet into solid_web_ui (precompiled, shipped with the gem)"
  task :build do
    sh "bin/build-css"
  end
end
