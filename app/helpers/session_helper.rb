module SessionHelper

  SESSION_COOKIE_NAME = 'MWBSID'

  def sign_in(user)
    #generate a session and session key
    @session_record = SessionRecord.new({user_id:user.id})

    #persist it to database
    @session_record.save!

    #give it to the user as a cookie
    cookies[SESSION_COOKIE_NAME] = {
      value: session_record.key,
      expires: 1.day.from_now
    }

  end

  def sign_out
    #delete the session record
    @session_record.destroy if @session_record

    #overwrite any cookies
    @current_user = @session_record = cookies[SESSION_COOKIE_NAME] = nil

  end

  def signed_in?
    true unless current_user.nil?
  end

  def current_user
    @current_user ||= User.find_by_id(session_record.user_id)
  end

  def session_record
    @session_record ||= SessionRecord.find_by_key(cookies[SESSION_COOKIE_NAME])
  end

  def is_admin?
    current_user.is_admin.to_boolean
  end

end