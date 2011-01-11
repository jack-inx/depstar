# config/initializers/smtp_settings.rb
ActionMailer::Base.smtp_settings = {
  :address => "mail.depstar.com",
  :port => 587,
  :authentication => :plain,
  :enable_starttls_auto => true,
  :user_name => "info@depstar.com",
  :password => "depstar1234"
}