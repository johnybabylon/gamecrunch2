class Users::RegistrationsController < Devise::RegistrationsController
 before_filter :configure_sign_up_params, only: [:create]
 before_filter :configure_account_update_params, only: [:update]
 #before_filter :update_sanitized_params, if: :devise_controller?

  # GET /resource/sign_up
  def new
     redirect_to welcome_index_path
   end

  # POST /resource
  # def create
  #   super
  # end

  # GET /resource/edit
   def edit
     redirect_to welcome_index_path

   end

  # PUT /resource
   def update
     redirect_to welcome_index_path

   end

  # DELETE /resource
  # def destroy
  #   super
  # end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

   protected

  # If you have extra params to permit, append them to the sanitizer.
   def configure_sign_up_params
    devise_parameter_sanitizer.for(:sign_up) << :attribute
   end

  # If you have extra params to permit, append them to the sanitizer.
   def configure_account_update_params
     params.require(:user).permit(:email, :password, :password_confirmation, :current_password, :phone)
   end

 def after_update_path_for(resource)
   welcome_index_path(resource)
 end

 #def update_sanitized_params
 #  devise_parameter_sanitizer.for(:sign_up) {|u| u.permit(:name, :email, :password, :password_confirmation, :number)}
 #end
  # The path used after sign up.
  # def after_sign_up_path_for(resource)
  #   super(resource)
  # end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end
end
