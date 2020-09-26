class Api::V1::ContactstypesController < ApplicationController
  def index
    contactstypes = Contactstype.order('created_at DESC');
    render json: {status:"SUCCESS", message:'Loaded types of contacts', data:contactstypes},status: :ok
  end
  def show
    contactstype =  Contactstype.find(params[:id]);
    render json: {status:"SUCCESS", message:'Loaded type of contacts', data:contactstype},status: :ok
  end
  def create
    contactstype =  Contactstype.new(contactstype_params);
    begin
      if contactstype.save
        render json: {status:"SUCCESS", message:'added type of contacts', data:contactstype},status: :ok
      else
        render json: {status:"ERROR", message:'type of contacts not added',
          data:contactstype.errors},status: :unprocessable_entity
      end
      rescue ActiveRecord::RecordNotUnique
            render json: {status:"ERROR", message:'type of contacts not added',
              data:'type alredy exist'},status: :unprocessable_entity
    end
  end

  def destroy
    begin
      contactstype =  Contactstype.find(params[:id]);
      contactstype.destroy
      render json: {status:"SUCCESS", message:'type of contacts is destroyed', data:contactstype},status: :ok
    rescue ActiveRecord::RecordNotFound
          render json: {status:"ERROR", message:'type of contacts not destroyed',
            data:'type not exist'},status: :unprocessable_entity
    end
  end
  def update
    begin
      contactstype =  Contactstype.find(params[:id]);
      if contactstype.update(contactstype_params)
        render json: {status:"SUCCESS", message:'type of contacts is updated', data:contactstype},status: :ok
      else
        render json: {status:"ERROR", message:'type of contacts is not updated',
          data:contactstype.errors},status: :unprocessable_entity
      end
    rescue ActiveRecord::RecordNotFound
        render json: {status:"ERROR", message:'type of contacts not updated',
          data:'type not exist'},status: :unprocessable_entity
    rescue  ActiveRecord::RecordNotUnique
            render json: {status:"ERROR", message:'type of contacts not updated',
              data:'updated type is not unique'},status: :unprocessable_entity
    end
  end

  private
  def  contactstype_params
    params.permit(:name, :regex)
  end
end
