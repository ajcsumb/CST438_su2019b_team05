require 'httparty'

class OrdersController < ApplicationController
    skip_before_action :verify_authenticity_token


    # Create POST /orders
    # Request body contains JSON data with the itemId
    # and email of customer
    def create
        # Create the order 
        @order = Order.new
        @order.itemId = params[:itemId]
        @order.description = ""
        @order.price = ""
        @order.award = 0
        @order.total = 0
        @email = params[:email]
        
        # Invoke the customer service to retrieve the customer id using the customers
        # email address
        # Something like:
        # @order.customerId = getCustomerId(params[:email])
        response = CustomerService.getCustomerByEmail(@email)
        # Was using the following for debugging
        puts "This is the status code in the Orders Controller: " + response.code.to_s
        # Assign the customerId back over to the order.
        @order.customerId = response["id"]
        
        
        # All other data is optional
        
        # Description
        if params.has_key?(:description)
            # Assign it to the order
            @order.description = params[:description]
        else
            @order.description = ""
        end
        
        # Award
        if params.has_key?(:award)
            # Assign it to the order
            @order.award = params[:award]
        else
            @order.award = 0.00
        end
        
        # Price
        if params.has_key?(:price)
            # Assign it to the order
            @order.price = params[:price]
        else
            @order.price = 0.00
        end
        
        # Total
        if params[:award] == 0 || @order.award == 0
            # Assign it to the order
            @order.total = @order.price
        elsif params.has_key?(:total)
            # Assign it to the order
            @order.total = params[:total]
        else
            @order.total = 0.00
        end
        
        # Save the order
        @order.save
        
        # Check to see if it was successful
        if @order.valid?
            render json: @order.to_json, status: 201
        else
            # The order was not successful
            render json: @order.to_json, status: 400
        end
    end
    
    # GET /orders/id=:id
    def getById
        # Get the ID from the params
        @id = params[:id]
        # Check to make sure the id is not null
        if !@id.nil?
            # Search db for the order
            @order = Order.find_by(id: @id)
            # If the order is found
            if !@order.nil?
                # Return it along with a status of 200
                render json: @order.to_json, status: 200
            else
                # If it could not be found
                head 404
            end
            
        else
            # There was no id value passed.
            head 404
        end
        
    end
    
    # GET /orders?customerId=nnn
    # GET /orders?email=nn@nnn
    def get
        # Get the cusomter id from the params
        @customerId = params[:customerId]
        # Get the customer email from the params
        @customerEmail = params[:email]
        # Check to make sure the id is not null
        if !@customerId.nil? 
            @orders = Order.where(customerId: @customerId)
            # Check to make sure the orders are found.
            if !@orders.nil?
                render json: @orders.to_json, status: 200
            end
        elsif !@customerEmail.nil?
            response = CustomerService.getCustomerByEmail(@customerEmail)
            # Was using the following for debugging
            puts "This is the status code in the Orders Controller: " + response.code.to_s
            # Assign the customerId back over to the order.
            id = response["id"]
            @orders = Order.where(customerId: id)
            if !@orders.nil?
                render json: @orders.to_json, status: 200
            end
        end
    end
end

class CustomerService 
    include HTTParty
        
    base_uri "http://localhost:8081"
    format :json
    
    def self.getCustomerByEmail(email)
        puts "Getting the customer with the email of #{email}"
        get "/customers?email=#{email}"
    end
    
    # def postOrderToCustomer(order)
         
    # end
end

