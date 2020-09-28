# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
   before_action :configure_sign_up_params, only: [:create]
  # before_action :configure_account_update_params, only: [:update]

  # GET /resource/sign_up
  # def new
  #   super
  # end

  # POST /resource
   def create
     #super
     my_params =  devise_parameter_sanitizer.sanitize(:sign_up)
     puts my_params
     user =  User.new(my_params)
     person =  Person.where(my_params[:person_attributes]).take()
     if (person)
       user.person = person
     end
     begin
        arg = Proc.new {true}
        if user.person.contacts.find(arg) {|c| c.data == user.email}
          email = Email.new(data: my_params[:email], description: 'используется для аутенификации')
          user.person.contacts.push(email)
        end

       if user.save
         render json: {status:"SUCCESS", message:'get params:', data: user},status: :ok
       else
         render json: {status:"ERROR", message: devise_parameter_sanitizer.sanitize(:sign_up),
           data: user.errors},status: :unprocessable_entity
       end
       rescue ActiveRecord::RecordNotUnique
             render json: {status:"ERROR", message:'user not added',
               data:'user alredy exist'},status: :unprocessable_entity
     end

   end

  # GET /resource/edit
  # def edit
  #   super
  # end

  # PUT /resource
  # def update
  #   super
  # end

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
     devise_parameter_sanitizer.permit(:sign_up, keys: [:email, :login, :password, person_attributes: [:name, :surname, :middlename, :description]])
  end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_account_update_params
  #   devise_parameter_sanitizer.permit(:account_update, keys: [:email, :login, :password, person_attributes: [:id, :name, :surname, :middlename, :description]])
  # end

  # The path used after sign up.
  # def after_sign_up_path_for(resource)
  #   super(resource)
  # end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end
end
