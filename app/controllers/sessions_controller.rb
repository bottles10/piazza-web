class SessionsController < ApplicationController
  skip_authentication only: %i[ new create ]

  def new
  end

  def create
    @app_session = User.create_app_session(
      email: login_params[:email],
      password: login_params[:password]
    )

    if @app_session
      log_in(@app_session)
      redirect_to root_path, status: :see_other, notice: t(".success")
    else
      flash.now[:alert] = t(".incorrect_details")
      render :new, status: :unprocessable_content
    end
  end

  private

    def login_params
      @login_params ||= params.expect(user: [:email, :password] )
    end
end
