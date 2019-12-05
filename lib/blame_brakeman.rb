require 'fileutils'

module BlameBrakeman
class BrakemanSecurity
  
  def initialize(version_control = nil, from = nil, to = nil)
    @version_control = version_control
    @from = from
    @to = to
  end
  
  def brakeman_security
    FileUtils.mkdir_p 'brakeman'
    root_folder = "brakeman"
    time_now = Time.now
    time_yesterday = time_now - 86400 #1 Day Ago
    brakeman_file_format = "security_#{time_format(time_yesterday)}.json"
    comparison_file_format = "security_comparison_#{time_format(time_yesterday)}_to_#{time_format(time_now)}.json"
    format = %w[json html]
    if File.exist?("#{root_folder}/#{brakeman_file_format}")
      comparison_file = "#{root_folder}/#{comparison_file_format}"
      system("brakeman --compare #{root_folder}/#{brakeman_file_format} -o #{comparison_file}")
      format.each { |fr| system("rm -f #{root_folder}/security_#{time_format(time_yesterday)}.#{fr}") }
      create_security_file(root_folder, format, time_format(time_now))
      condition = override_comparison_file(comparison_file)
    else
      create_security_file(root_folder, format, time_format(time_now))
      puts 'Yesterday,Security File not there!!!.In that folder'
      puts 'Create File: brakeman -o brakeman/security_MMDDYYYY.json'
    end
  end
  
  def override_comparison_file(file)
    output = {}
    data = File.read(file)
    json_data = JSON.parse(data)
    condition = json_data['new'].blank? && json_data['fixed'].blank?
    return condition if condition
    
    # Overwrite JSON Data - Add Blame
    json_data.each do |key, value|
      value.each do |hash|
        output[key] = add_gitblame(hash)
      end
    end
    # Overwrite Comparison File
    File.open(file, 'w') do |f|
      f.puts JSON.pretty_generate(json_data)
    end
    condition
  end
  
  def add_gitblame(hash)
    file = hash['file']
    line = hash['line']
    if @version_control == 'git'
      git_blame = `git blame -L #{line},#{line} #{file}`
      hash['blame'] = git_blame
      hash
    else
      hash
    end  
  end
  
  def create_security_file(root_folder, format, time_format)
    format.each { |fr| system("brakeman -o #{root_folder}/security_#{time_format}.#{fr}") }
  end
  
  def time_format(time)
    time.strftime('%m%d%Y')
  end
end
end
