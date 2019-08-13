require 'httparty'
require_relative 'customer_service'
require_relative 'item_service'

class OrderClient
    
    include HTTParty
    
    base_uri "http://localhost:8080"
    format :json
    
    @gameOver = false
    
    # Order section
    
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
    
    # response = OrderClient.registerOrder(1, "123@132.com")
    # puts "HTTP Status Code: " + response.code.to_s
    # # puts response
    # # puts "HTTP Reponse body: " + response.body.to_s
    # puts "\n"
    
    # response = OrderClient.getOrderById(1)
    # puts response.code.to_s
    # puts response.body.to_s
    # test = response.body.to_json
    # puts test["id"]
    
    # response = OrderClient.getOrdersByCustomerId(2)
    # puts "HTTP Status Code: " + response.code.to_s
    # # puts "HTTP Response Body: " + response.body.to_s
    
    # response = OrderClient.getOrdersByCustomerEmail("ade-la-costa@csumb.edu")
    # puts "HTTP Status Code: " + response.code.to_s
    # # puts "HTTP Response Body: " + response.body.to_s
    
    # Interation Section
    while @gameOver == false do
        puts "Please enter the number corresponding to your option:"
        puts "1. Register a new customer"
        puts "2. Get customer by id"
        puts "3. Get customer by email"
        puts "4. Get item by id"
        puts "5. Register a new item"
        puts "6. Create a new order"
        puts "7. Get order by orderId"
        puts "8. Get order by customerId"
        puts "9. Get order by customer email"
        puts "0. Quit"
        
        input = gets.to_i
        
        if input == 0 
            puts "Good bye!"
            @gameOver = true
        
        elsif input == 1
            puts "Please enter the first name: "
            fn = gets.chomp!
            puts "Please enter the last name: "
            ln = gets.chomp!
            puts "Please enter the email address: "
            e = gets.chomp!
            
            response = Customer_Service.registerCustomer(fn, ln, e)
            puts "HTTP Status Code: " + response.code.to_s
            puts "HTTP Reponse body: " + response.body.to_s
            puts "\n"
            
        elsif input == 2
            puts "Please enter id: "
            id = gets.to_i
            response = Customer_Service.getCustomerById(id)
            puts "HTTP Status Code: " + response.code.to_s
            puts "HTTP Reponse body: " + response.body.to_s
            puts "\n"
            
        elsif input == 3
            puts "Please enter email address: "
            email = gets
            code, customer = Customer_Service.getCustomerByEmail(email)
            puts "HTTP Status Code: " + code.to_s
            puts "HTTP Reponse body: " + customer.to_s
            puts "\n"
        elsif input == 4
            puts "Please enter item id: "
            id = gets.to_i
            response = Item_Service.getItem(id)
            puts "HTTP Status Code: " + response.code.to_s
            puts "HTTP Reponse body: " + response.body.to_s
            puts "\n"
        elsif input == 5
            puts "Please enter the price: "
            price = gets.chomp!

            puts "Please enter the description: "
            d = gets.chomp!
            puts "Please enter the quantity: "
            q = gets.to_i
            
            response = Item_Service.createItem(price, d, q)
            puts "HTTP Status Code: " + response.code.to_s
            puts "HTTP Reponse body: " + response.body.to_s
            puts "\n"
            
        elsif input == 6
            puts "Please enter itemId: "
            itemId = gets.to_i
            puts "Please enter customer email: "
            email = gets.chomp!
            
            response = OrderClient.registerOrder(itemId, email)
            puts "HTTP Status Code: " + response.code.to_s
            puts "HTTP Reponse body: " + response.body.to_s
            puts "\n"
            
        elsif input == 7
            puts "Please enter order id: "
            orderId = gets.to_i
            response = OrderClient.getOrderById(orderId)
            puts "HTTP Status Code: " + response.code.to_s
            puts "HTTP Reponse body: " + response.body.to_s
            puts "\n"
            
        elsif input == 8
            puts "Please enter customer id: "
            cId = gets.to_i
            response = OrderClient.getOrdersByCustomerId(cId)
            puts "HTTP Status Code: " + response.code.to_s
            puts "HTTP Reponse body: " + response.body.to_s
            puts "\n"
            
        elsif input == 9
            puts "Please enter customer email: "
            cEmail = gets.chomp!
            response = OrderClient.getOrdersByCustomerEmail(cEmail)
            puts "HTTP Status Code: " + response.code.to_s
            puts "HTTP Reponse body: " + response.body.to_s
            puts "\n"
            
        else
            puts "************ Please enter a valid option ***************\n"
        end
        
    end
end