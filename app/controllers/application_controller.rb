class ApplicationController < ActionController::API
    before_action :authorized
    # dito papasok pag maglologinn
    def encode_token(payload)
    JWT.encode(payload, 'yourSecret')
  end

  def auth_header
    # { Authorization: 'Bearer <token>' }
    request.headers['Authorization']
  end

  # check if the auth header is exising ot not and split it and get the token and decode it using HS256
  def decoded_token
    if auth_header
      token = auth_header.split(' ')[1]
      # header: { 'Authorization': 'Bearer <token>' }
      begin
        JWT.decode(token, 'yourSecret', true, algorithm: 'HS256')
      rescue JWT::DecodeError
        nil
      end
    end
  end
  
  # check if the decode token has value and not nil
  def logged_in_user
    if decoded_token
      user_id = decoded_token[0]['user_id']
      @user = User.find_by(id: user_id)
    end
  end
  
  def logged_in?
    !!logged_in_user
  end
  
  #  check if it is logged_ in or not
  def authorized
    render json: { message: 'Please log in' }, status: :unauthorized unless logged_in?
  end
end