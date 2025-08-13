class UsersController < ApplicationController
  skip_authentication only: %i[ new create ]
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      organization = Organization.create(members: [@user])
      @app_session = @user.app_sessions.create
      log_in(@app_session)

      redirect_to root_path, status: :see_other, notice: t(".welcome", name: @user.name)
    else
      render :new, status: :unprocessable_content
    end
  end

  private

    def set_user
      @user = User.find(params.expect(:id))
    end

    def user_params
      params.expect(user: [:name, :email, :password])
    end
end
