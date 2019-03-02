require 'json'
desc "create a static javascript translation file with each language available as a JSON object"
task :locale_js => :environment do
  require 'fileutils'

  resources = {}
  Dir["config/locales/*.yml"].each do |fn|
    langfile = YAML::load(File.open(fn))    
    langfile.each do |key, values|
      resources[key] ||= {}
      resources[key].merge! values
    end
  end
  

  %w(cs en).each do |lang|
    
    langfilejs = File.join(Rails.root, "app", "assets", "javascripts", "mapserver", "locale", "#{lang}.js")
    
    FileUtils.mkdir_p(File::dirname(langfilejs))
    
    File.open(langfilejs, 'w') do |f|
      f.write("Config.locale = '#{lang}';\n")
      f.write("Config.resourceString = " + resources[lang]['mapserver'].to_json + ";\n\n")
    end
    
  end
  
end