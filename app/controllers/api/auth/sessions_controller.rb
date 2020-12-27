#frozen_string_literal: true

class Api::Auth::SessionsController < Devise::SessionsController  
  prepend_before_action :require_no_authentication, only: [:new, :create]
  before_action  :load_messages
  
  attr_accessor :message  
  # POST /resource/sign_in
   def create      
     @user = User.find_by(login: params[:login])     
    if @user&.valid_password?(params[:password])       
      sign_in(:user, @user)      
      token = JsonWebToken.encode(sub: @user.id)
      SessionList.instance.add(token, @user)      
      render json: { token: token, person: @user.person, message: self.message[:signed_in] }
    else       
       render json: {status:"ERROR", message: message[:invalid]},status: 401
    end
  end

  # DELETE /resource/sign_out
   def destroy          
    signed_out = Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name)    
    render json: { message:  self.message[:signed_out], signed_out: signed_out }    
   end

   def verify_signed_out_user
    header = request.headers['Authorization']
    header = header.split(' ').last if header  
    if SessionList.instance.exist(header)
       SessionList.instance.remove(header) 
    else        
      render json: {error: 'session not found'}, status: 402      
    end    
   end

   private 

   def load_messages
      self.message = find_message(:sessions, {scope: :devise}) 
   end 

   def respond_to_on_destroy
    
   end
   
     
end
