# -*- coding: utf-8 -*-
$:.unshift("/Library/RubyMotion/lib")
require 'motion/project/template/osx'

begin
  require 'bundler'
  Bundler.require
rescue LoadError
end

Motion::Project::App.setup do |app|
  # Use `rake config' to see complete project settings.
  app.name = 'comix'
  app.identifier = 'org.aduca.comix'
  app.copyright = "Copyright © 2015 Sho Kusano. All rights reserved."
  app.frameworks << 'Quartz'

  app.pods do
    instance_eval(File.read('Podfile'))
  end
end
