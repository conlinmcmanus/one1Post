class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user, only: %i[show edit update destroy finish_signup]

  # GET /users/:id.:format
  def show
    # authorize! :read, @user
  end

  # GET /users/:id/edit
  def edit
    # authorize! :update, @user
  end

  # PATCH/PUT /users/:id.:format
  def update
    # authorize! :update, @user
    respond_to do |format|
      if @user.update(user_params)
        sign_in(@user == current_user ? @user : current_user, bypass: true)
        flash[:success] = 'Your profile was successfully updated.'
        redirect_to @user
        format.json { head :no_content }
      else
        render action: 'edit'
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # GET/PATCH /users/:id/finish_signup
  def finish_signup
    # authorize! :update, @user
    if request.patch? && params[:user]
      if @user.update(user_params)
        # @user.skip_reconfirmation!
        sign_in(@user, bypass: true)
        flash[:success] = 'Your profile was successfully updated.'
        redirect_to posts_path
      else
        flash[:danger] = 'An account already exists with that email.'
        redirect_to finish_signup_path
      end
    end
  end

  # DELETE /users/:id.:format
  def destroy
    # authorize! :delete, @user
    @user.destroy
    respond_to do |format|
      redirect_to root_url
      format.json { head :no_content }
    end
  end

  %w[twitter facebook linkedin google_oauth2].each do |provider|
    class_eval %{
      def unlink_#{provider}
        User.where(id: current_user.id).first.identities.where(provider_id: Provider.where(name: "#{provider}").first.id).first.destroy
        redirect_to root_path
      end
    }
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    accessible = %i[name email] # extend with your own params
    accessible << %i[password] unless params[:user][:password].blank?
    params.require(:user).permit(accessible)
  end
end
