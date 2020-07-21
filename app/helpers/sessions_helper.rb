module SessionsHelper
  # save id in session cookie
  def log_in user
    session[:user_id] = user.id
  end

  # check user login ?
  def logged_in?
    current_user.present?
  end

  # delete user in session and cookie
  def log_out
    forget current_user
    session.delete :user_id
  end

  # Get User in Session or Cookie
  def current_user
    if (user_id = session[:user_id])
      User.find_by(id: user_id)
    elsif (user_id = cookies.signed[:user_id])
      user = User.find_by(id: user_id)
      log_in user if user&.authenticated?(cookies[:remember_token])
    end
  end

  # Verify user vs user login
  def current_user? user
    user && user == current_user
  end

  # remember id , token in cookie
  def remember user
    user.remember
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end

  # delete id , token in cookie
  def forget user
    user.forget
    cookies.delete :user_id
    cookies.delete :remember_token
  end

  # Redirects to stored location (or to the default).
  def redirect_back_or default
    redirect_to(session[:forwarding_url] || default)
    session.delete(:forwarding_url)
  end

  # Stores the URL trying to be accessed.
  def store_location
    session[:forwarding_url] = request.original_url if request.get?
  end
end
