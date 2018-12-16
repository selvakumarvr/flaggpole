desc "This task is called by the Heroku cron add-on"
task :send_daily_mailers => :environment do
  Rails.logger.info "Starting scheduler.rake :send_daily_mailers task"
  
  Time.zone = 'Eastern Time (US & Canada)'  
  Ncm.delay.send_daily_mailers

  Rails.logger.debug "Ending task."
end
