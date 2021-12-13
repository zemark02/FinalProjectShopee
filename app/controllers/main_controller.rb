class MainController < ApplicationController
  skip_before_action :verify_authenticity_token ,only: %i[login check_valid_login]
  before_action :landing_page, only: [:login ,:check_valid_login]
  def login
    session[:user_id] = nil
    @user = User.new
  end

  def check_valid_login
    @user = User.new(user_params)
    respond_to do |format|
      if(@user.login)
        session[:user_id] = @user.id
        format.html { redirect_to "/feed/#{@user.id}"}
      else
        session[:user_id] = nil
        format.html {render template: 'main/login',status: :unprocessable_entity}
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def user_params
      params.require(:user).permit(:username, :password)
    end
end
