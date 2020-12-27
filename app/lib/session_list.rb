class SessionList
    include Singleton

     attr_accessor :LIST
     LIST =  Hash.new

    def add(token, user)        
      LIST.store(token, user)
    end

    def remove(token)        
      LIST.delete(token)         
    end

    def exist(token)
      LIST.member?(token)         
    end
    def get(token)
      LIST[token]  
    end    
end    