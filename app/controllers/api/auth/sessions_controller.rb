#frozen_string_literal: true

class Api::Auth::SessionsController < Devise::SessionsController  
  prepend_before_action :require_no_authentication, only: [:new, :create]
  before_action  :load_messages
  
  attr_accessor :message 

  # get /resource/sign_in.json 
  def new
     render json: {status: 401, error: 'session invalidate'}
  end
  # POST /resource/sign_in
  def create      
    if  params[:email] 
      @user = User.find_by(email: params[:email])
    else
      @user = User.find_by(login: params[:login])
    end       
    if @user&.valid_password?(params[:password])       
      sign_in(:user, @user)      
      token = JsonWebToken.encode(sub: @user.id)
      SessionList.instance.add(token, @user) 
      @log = Audit.new(user_id: @user.id, action: :signed_in, 
        summary: "user signed_in", detail: self.message[:signed_in], 
        severity: :success, created_at: DateTime.current()) 
      puts @log.to_json   if !@log.save!  
      render json: {token: token, data: {login: @user.login, 
        email: @user.email, job: @user.job,  member: @user.member, 
        name: @user.person.full_name}, message: self.message[:signed_in] }
    else       
       render json: {status:"ERROR", message: self.message[:invalid]}, status: 202
    end
  end

  # DELETE /resource/sign_out
   def destroy          
    signed_out = Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name)
    @log = Audit.new(user_id: @user.id, action: :signed_out, 
        summary: "user signed_out", detail: self.message[:signed_out], 
        severity: :success, created_at: DateTime.current())      
      @log.save!    
      render json: { message:  self.message[:signed_out], signed_out:  signed_out}        
   end

   def verify_signed_out_user
    header = request.headers['Authorization']
    header = header.split(' ').last if header  
    if SessionList.instance.exist(header)
       @user = SessionList.instance.get(header)
       SessionList.instance.remove(header) 
    else        
      render json: {status: 401, error: 'session not found'}     
    end    
   end

   private 

   def load_messages
      self.message = find_message(:sessions, {scope: :devise}) 
   end 

   def respond_to_on_destroy
    
   end   
   
end
