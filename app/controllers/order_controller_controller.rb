class OrderControllerController < ApplicationController
    
    # Create POST /orders
    # Request body contains JSON data with the itemId
    # and email of customer
    def create
        # Create the order 
        @order = Order.new
        @order.itemId = params[:itemId]
        
        # Invoke the customer service to retrieve the customer id using the customers
        # email address
        # Something like:
        # @order.customerId = getCustomerId(params[:email])
        
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
        if params[:award] == 0 || @orders.award == 0
            # Assign it to the order
            @order.total = @order.price
        elsif params.has_key?(:total)
            # Assign it to the order
            @order.total = params[:total]
        else
            @order.total = 0.00
        end
    end
end
