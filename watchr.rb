watch('test/spec_helper\.rb') { run_all_specs }
watch('test/.*/.*_spec\.rb') { |match| run_spec(match[0]) }
watch('lib/.*/.*\.rb') do |match|
   related_specs(match[0]).map do |spec|
      run_spec(spec)
   end
end

Signal.trap 'INT' do
   abort("\n")
end

def notify( message )
   title = "Watchr"
   options = "-t 2 -i actions/document-send.png"
   system %(notify-send #{options} #{title} #{message} &)
end

def run_spec( filename )
   `clear`
   result = run(%Q(ruby -I"lib:spec" -rubygems #{filename}))
   notify( result.split("\n").last ) rescue ""
   puts result
end

def run_all_specs
   `clear`
   result = run "rake spec"
   notify( result.split("\n").last ) rescue ""
   puts result
end

def related_spec_files(path)
   Dir['spec/**/*.rb'].select do |file|
      file =~ /#{File.basename(path).split(".").first}_spec.rb/
   end
end
