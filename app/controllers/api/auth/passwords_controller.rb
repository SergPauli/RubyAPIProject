# frozen_string_literal: true

class Api::Auth::PasswordsController < Devise::PasswordsController
  prepend_before_action :require_no_authentication, only: [:new, :create]

  # GET /resource/password/new
   def new
     User.find(params[:id]).reset_password('password123', 'password123')
     render json: { message: 'passord reset to password123' }
   end

  # POST /resource/password
  # def create
  #   super
  # end

  # GET /resource/password/edit?reset_password_token=abcdef
  # def edit
  #   super
  # end

  # PUT /resource/password
  # def update
  #   super
  # end

  # protected

  # def after_resetting_password_path_for(resource)
  #   super(resource)
  # end

  # The path used after sending reset password instructions
  # def after_sending_reset_password_instructions_path_for(resource_name)
  #   super(resource_name)
  # end
end
