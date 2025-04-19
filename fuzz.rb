
require 'timeout'
require 'fileutils'

def check_character_in_file(file_path, char)
  return false unless File.exist?(file_path)
  File.read(file_path).include?(char)
end


$proj_thing = Project.find(1) # Was originally 0
$context = { project: $proj_thing, no_sourcepos: true } # Context here.

def target_function(data)
	# Timeout::timeout 1 do
  begin
    # NOTE: Here you would put the part of gitlab which you would like to fuzz. Here I just print the username of the first user (should usually be root) and then if the length of the inputted data is 100, then print the string "The length is 100 characters!" . Normally here you would put some part of the gitlab code, which parses user input. The timeout is there to catch timeouts, which could be indicative of Denial Of Service vulnerabilities.


    if (!(data.include?("alert(") && data.include?(")")))
      # puts "stuff not found!!!"
      return
    end

    doc = Banzai::Pipeline::PreProcessPipeline.call(data, {})
    doc = Banzai::Pipeline::FullPipeline.call(doc[:output], $context)
    res = (doc[:output]).to_html # Convert to html
    # puts "stuff is found!!!"

    #if check_character_in_file("/home/oof/dev/gdk/gitlab/tmp/output.txt", '1')
    #  raise "Vuln found!"
    #end
    File.write("/home/oof/dev/gdk/gitlab/tmp/input.txt", res.to_s)

    #if check_character_in_file("/home/oof/dev/gdk/gitlab/tmp/output.txt", '1')
    #  raise "Vuln found!"
    #end


	rescue RuntimeError, TypeError, Encoding::CompatibilityError, Timeout::Error
		return
	end
end

test_one_input = lambda do |data|
	target_function(data) # Your fuzzing target would go here
	return 0
end

Ruzzy.fuzz(test_one_input)

