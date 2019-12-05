Gem::Specification.new do |s|
    s.name        = 'blame_brakeman'
    s.version     = '0.0.3'
    s.licenses    = ['MIT']
    s.summary     = "Blame Brakeman"
    s.description = "'git blame' added Brakeman JSON warnings. We have all the information at brakeman security warnings. 
                      But, Don't have a blame option for which developer done the vulnerabilities.Below is example.
                      
        {
         ....
        'blame': 'xxxxxxxxxxxxx (developer_name 2019-07-17 20:59:12 +0530 4226)  params.require(:users).permit!\r\n'
         ...
        }"
    s.authors     = ["Honestraj Kandhasamy"]
    s.email       = 'honestraj.it@gmail.com'
    s.files       = ["lib/blame_brakeman.rb"]
    s.homepage    = 'https://rubygems.org/gems/blame_brakeman'
    s.metadata    = { "source_code_uri" => "https://github.com/honestveera/blame_brakeman" }
end