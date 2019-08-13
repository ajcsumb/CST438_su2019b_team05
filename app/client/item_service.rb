class Item_Service
include HTTParty
        
    base_uri "http://localhost:8082"
    format :json
    
    @headersAccept = {
        "ACCEPT" => "application/json"
    }
    
    @headersContentType = {
        "CONTENT_TYPE" => "application/json"
    }
    
    def self.getItemById(id)
        puts "Getting Item with the id of #{id}"
        response = get "/items?id=#{id}",
        headers: @headersAccept
        
        status = response.code
        if status == 200
            item = JSON.parse response.body, symbolize_names: true
        end
        
        return status, item
    end
    
    def self.postOrder(order)
        response = put "/items/order",
            body: order.to_json,
            headers: @headersContentType
        return response.code
    end
    
    # For client
    def self.createItem(price, description, stockQty)
        item = {
        'price' => price,
        'description' => description,
        'stockQty' => stockQty }
        
        post "/items",
          body: item.to_json,
          headers: {'Content-Type' => 'application/json', 'ACCEPT' => 'application/json' }
    end
    
    def self.getItem(id)
        get "/items?id=#{id}"
    end
end