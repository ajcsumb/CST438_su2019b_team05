class Customer_Service
    include HTTParty
        
    base_uri "http://localhost:8081"
    format :json
    
    @headersAccept = {
        "ACCEPT" => "application/json"
    }
    
    @headersContentType = {
        "CONTENT_TYPE" => "application/json"
    }
    
    def self.getCustomerByEmail(email)
        puts "Getting the customer with the email of #{email}"
        response = get "/customers?email=#{email}",
        headers: @headersAccept
        
        status = response.code
        if status == 200
            customer = JSON.parse response.body, symbolize_names: true
        end
        
        return status, customer
    end
    
    def self.postOrder(order)
        response = put "/customers/order",
            body: order.to_json,
            headers: @headersContentType
        return response.code
    end
    
    # For client program
    def self.registerCustomer(firstName, lastName, email)
        # Create the customer
        customer = {
            'firstName' => firstName,
            'lastName' => lastName,
            'email' => email
        }
        
        post "/customers", 
            body: customer.to_json,
            headers: {'Content-Type' => 'application/json', 
                        'ACCEPT' => 'application/json' }
        
    end
    
    def self.getCustomerById(id)
        get "/customers?id=#{id}"
    end
    
    # def self.getCustomerByEmail(email)
    #     get "/customers?email=#{email}"
    # end
end