class ChangePasswordJob < Struct.new(:zip, :new_password)
  def perform
    pwdlogger = Logger.new(File.join(Rails.root,'log','change_password_fail.log'))
    tz = TwitterZip.find_by_zip(zip)
    success = tz.change_password(new_password)
    unless success
      pwdlogger.info tz.zip
    end
  end
end
