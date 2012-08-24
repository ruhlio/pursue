require 'ramaze'
require 'yaml'
require 'log4r'
require 'log4r/yamlconfigurator'
require 'log4r/outputter/fileoutputter'
require 'log4r/outputter/consoleoutputters'

Ramaze.options.roots = [__DIR__]
Log4r::YamlConfigurator.load_yaml_file('config/log4r.yaml')

class Ramaze::Controller
   @@settings = YAML::load( File.open('config/settings.yaml') )
end

Dir.glob('controllers/*.rb').each do |controller|
   require controller
end
