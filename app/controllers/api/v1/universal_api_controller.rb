class Api::V1::UniversalApiController < ApiController    
    before_action :prepare_model, only: [:index, :show, :create, :update, :destroy]
    before_action :find_record, only: [:update, :destroy]    
    before_action :get_user, only: [:create, :update, :destroy]
    def index
      @res = @model_class
      @res = @res.limit(params[:limit].to_i) if params[:limit]
      @res = @res.offset(params[:offset].to_i) if params[:offset]
      select_list = permitted_select_values
      @res = @res.select(select_list) if select_list
      @res = @res.ransack(params[:q]).result
      if params[:include] 
        resultes_arr = Array.new       
        @resultes = @res.includes get_includes_model 
        @resultes.each do |r|
          if @model_class.nested_select_params 
            resultes_arr.push r.as_json include: @model_class.nested_select_params           
          else
            resultes_arr.push r.as_json include: get_includes_model 
          end           
        end
        render json: {status: 200, data: resultes_arr}   
      else
        @res = @res.count  if params[:count]     
        render json: {status: 200, data: @res}  
      end     
    end
    def show       
      select_list = permitted_select_values
      @res =  @model_class.select(select_list).find(params[@model_class.primary_key.to_sym]) if select_list   
      render json: {status: 200, data: @res}
    end
    def create
      if @res = @model_class.create(permitted_params)
        add_audit_record ((@res.respond_to? :guid) ? @res.guid : nil), :added, @model_class.primary_key, nil, @res.id, "Add record", "Object #{@res.to_s} added", :info 
        if params[:include]
          if @model_class.nested_select_params 
            render json: {status: 200, data: @res.as_json(include: @model_class.nested_select_params)}           
          else
            render json: {status: 200, data: @res.as_json(include: get_includes_model)} 
          end
        else  
          render json: {status: 200, data: @res} 
        end  
      else
        invalid_resource!(@res)
      end
    end
    def update      
      if @res.update(permitted_params)
        render json: {status: 200, data: @res}
      else
        invalid_resource!(@res)
      end
    end
    def destroy
      @res.destroy
      raise @res.errors[:base].to_s unless @res.errors[:base].empty?
      add_audit_record ((@res.respond_to? :guid) ? @res.guid : nil), :removed, @model_class.primary_key, @res.id, nil, "Delete record", "Object #{@res.to_s} removed", :warning 
      render json: {status: 200, data: true } 
    end
    
    protected
      # Обработка аудита изменений
      def add_audit_record guid, action, field, before, after, summary, detail, severity
        @log = Audit.new(guid: guid, action: action, field: field, before: before, after: after, summary: summary, 
          detail: detail, table: params[:model_name], user_id: @user.id, 
        severity: severity, created_at: DateTime.current())      
        @log.save!
      end

      def permitted_select_values
        if params[:select]
          case params[:select]
          when String
            permitted_select_value params[:select]
          when Array
            params[:select].map { |field| permitted_select_value field }.compact
          end        
        end
      end
      
      def permitted_select_value field
        @select_fields ||= @model_class.column_names + extra_select_values
        (@select_fields.include? field) ? field : nil
      end
      
      def extra_select_values
       if (params[:extselect]) 
         params[:extselect] 
       else 
        []
       end        
      end
      
      def permitted_params  
        nested  = params[:permitted].find {|key| key.include? "_attributes"}  
        permitted =  get_permitted_names
        permitted =  permitted.concat(@model_class.nested_attributes) if nested     
        params.permit(permitted) 
      end
      
      def get_permitted_names
        if params[:permitted]
          case params[:permitted]
          when String            
            params[:permitted].to_sym 
          when Array
            params[:permitted].map { |param| param.to_sym}
          end           
        end        
      end

      def get_model_name
        raise "Model User can not be used for that" if params[:model_name] == "User"
        params[:model_name] || controller_name.classify
      end

      def prepare_model
        model_name = get_model_name        
        raise "Model class not present" if model_name.nil? || model_name.strip == ""
        
        @model_class = model_name.constantize
        
        raise "Model class is not ActiveRecord" unless @model_class < ActiveRecord::Base
      end

      def get_includes_model
        if params[:include]
          case params[:include]
          when String            
           params[:include].to_sym 
          when Array
            params[:include].map { |model| model.to_sym }
          end        
        end
      end

      def find_record
        @res = @model_class.find(params[@model_class.primary_key.to_sym])
      end
      def get_user
        @user = current_user
      end  
  end