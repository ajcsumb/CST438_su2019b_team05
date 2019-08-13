class OrdersController < ApplicationController
    skip_before_action :verify_authenticity_token


    # Create POST /orders
    # Request body contains JSON data with the itemId
    # and email of customer
    def create
        # Create the order 
        @order = Order.new
        @email = params[:email]
        
        # Invoke the customer service to retrieve the customer id using the customers
        customerCode, customer = Customer_Service.getCustomerByEmail(@email)
        
        # Check to make sure the customer can be found
        if customerCode != 200
            render json: { error: "Customer could not be found. ", status: 400 }
            return
        end
        
        # Invoke the item service to retrieve the item information
        orderCode, item = Item_Service.getItemById(params[:itemId])
        # Check to see if the item can be found
        if orderCode != 200
            render json: { error: "Item could not be found", status: 400 }
            return
        end
        # Check to see if the item is in stock
        if item[:stockQty] <= 0
            render json: { error: "Item is out of stock", status: 400 }
            return
        end
        
        
        # Construct the object
        @order.itemId = params[:itemId]
        @order.description = item[:description]
        @order.customerId = customer[:id]
        @order.price = item[:price]
        @order.award = customer[:award]
        @order.total = @order.price - @order.award
        
        # Check to see if the order can be saved
        if @order.save 
            # Save the order to the customer and save it to the item
            tempCode = Customer_Service.postOrder(@order)
            tempCode = Item_Service.postOrder(@order)
            render json: @order, status: 201
        else
            render json: @order.errors, status: 400
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
            customerCode, customer = Customer_Service.getCustomerByEmail(@customerEmail)
            
            # Check to make sure the customer can be found
            if customerCode != 200
                render json: { error: "Customer could not be found. ", status: 400 }
                return
            end
            
            id = customer[:id]
            @orders = Order.where(customerId: id)
            if !@orders.nil?
                render json: @orders.to_json, status: 200
            end
        end
    end
end