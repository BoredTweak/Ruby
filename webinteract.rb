require 'watir'
require 'watir-scroll'

# Validate input values and inform user if there are errors
def validateInputParameters(args)   
    if ARGV.length < 2
        puts "Please specific username and password."
        puts "User: #{ARGV[0]}"
        puts "Password: #{ARGV[1]}"
        exit
    elsif ARGV.length > 4 
        puts "Too many arguments."
        exit
    end
        
    # assign values from input
    email = ARGV[0]
    password = ARGV[1]
    consoleLogging = ARGV[2] ? (true if ARGV[2] == "true") : false
    runHeadless = ARGV[3] ? (true if ARGV[3] == "true") : false
    return email, password, consoleLogging, runHeadless
end

def login(browser, email, password, consoleLogging = false)
    # Login
    
    puts "Opening login page" if consoleLogging
    browser.goto 'https://www.linkedin.com/uas/login?session_redirect=%2Fvoyager%2FloginRedirect%2Ehtml&fromSignIn=true&trk=uno-reg-join-sign-in'

    puts "Entering username" if consoleLogging
    browser.text_field(id: 'session_key-login').set(email)
    
    puts "Entering password" if consoleLogging
    browser.text_field(id: 'session_password-login').set(password)

    browser.button(id: 'btn-primary').click
    puts "Log in attempted" if consoleLogging
end

def touchProfile(browser, consoleLogging = false)
    # touch profile

    puts "Opening feed" if consoleLogging
    browser.goto 'https://www.linkedin.com/feed/'

    puts "Opening profile" if consoleLogging
    browser.goto 'https://www.linkedin.com/in/'

    puts "Opening edit header" if consoleLogging
    browser.a(class: ['pv-top-card-section__edit', 'pv-top-card-v2-section__edit', 'button-tertiary-medium-round', 'ember-view']).click

    puts "Editing Headline" if consoleLogging
    browser.textarea(id: 'topcard-headline').set('Software Engineer ')

    puts "Submitting Headline" if consoleLogging
    browser.div(class: 'pe-form-footer__actions').button(type: 'submit').click
end    

def main() 
    email, password, consoleLogging, runHeadless = validateInputParameters(ARGV)
    
    # Using Chrome for this  
    browser = Watir::Browser.new :chrome, headless: runHeadless
    
    login(browser, email, password, consoleLogging)    
    
    touchProfile(browser, consoleLogging)

    puts "Finished" if consoleLogging
    browser.quit
end

startTime = Time.now
main()
endTime = Time.now
totalTime = endTime - startTime
timeOutput = Time.at(totalTime).utc.strftime("%H:%M:%S")

puts "Elapsed Time: #{timeOutput}"