require 'httparty'

class OrderClient
    
    include HTTParty
    
    base_uri "http://localhost:8080"
    format :json
    
    def self.registerOrder(itemId, email)
        # Create the order
        order = {
            'itemId' => itemId,
            'email' => email
        }
        
        post "/orders", 
            body: order.to_json,
            headers: {'Content-Type' => 'application/json', 
                        'ACCEPT' => 'application/json' }
    end
    
    def self.getOrderById(id)
        get "/orders/#{id}"
    end
    
    def self.getOrdersByCustomerId(customerId)
        get "/orders?customerId=#{customerId}"
    end
    
    def self.getOrdersByCustomerEmail(email)
        get "/orders?email=#{email}"
    end
    
    # response = OrderClient.registerOrder(1, "ade-la-costa@csumb.edu")
    # puts "HTTP Status Code: " + response.code.to_s
    # # puts response
    # # puts "HTTP Reponse body: " + response.body.to_s
    # puts "\n"
    
    # response = OrderClient.getOrderById(1)
    # puts response.code.to_s
    # puts response.body.to_s
    # test = response.to_json
    # puts test.id
    
    response = OrderClient.getOrdersByCustomerId(2)
    puts "HTTP Status Code: " + response.code.to_s
    puts "HTTP Response Body: " + response.body.to_s
    
    response = OrderClient.getOrdersByCustomerEmail("ade-la-costa@csumb.edu")
    puts "HTTP Status Code: " + response.code.to_s
    puts "HTTP Response Body: " + response.body.to_s
end