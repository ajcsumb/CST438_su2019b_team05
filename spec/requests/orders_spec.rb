require 'rails_helper'

RSpec.describe "OrdersController", type: :request do
  
    # Global variables
    # Setup the Headers
    headers = { "CONTENT_TYPE" => "application/json",
                  "ACCEPT" => "application/json"}
  
    describe "POST /orders" do
        
        it "Customer makes purchase" do
            
        #1. This is input data for orders_controller
          order = { itemId: 1,                    
                    email: 'dw@csumb.edu' } 
                    
          headers = {"CONTENT_TYPE" => "application/json" ,
                     "ACCEPT" => "application/json"}    
        
        #2. Rspec double for Customer.getCustomerByEmail             
          expect(Customer_Service).to receive(:getCustomerByEmail).with('dw@csumb.edu') do    
            [ 200, {:id => 1, :award => 0 } ]
          end 
        
        #3. Rspec double for Item.getItemById  
          expect(Item_Service).to receive(:getItemById).with(1) do          
            [ 200, { :id =>1, :description =>'jewelry item',
                          :price => 175.00, :stockQty => 2 } ]
          end 
        
        #4. Rspec double for Customer.putOrder  
          allow(Customer_Service).to receive(:postOrder) do |order|      
            expect(order.customerId).to eq 1 
            201
          end 
          
        #5. Rspec double for Item.putOrder
          allow(Item_Service).to receive(:postOrder) do |order|         
            expect(order.itemId).to eq 1
            201
          end 
                    
          post '/orders', params: order.to_json, headers: headers
          
          expect(response).to have_http_status(201)
          order_json = JSON.parse(response.body)
          expect(order_json).to include('itemId'=> 1, 
                                        'description'=>'jewelry item',
                                        'customerId'=> 1 ,
                                        'price'=> 175.00,
                                        'award'=> 0,
                                        'total'=> 175.00 )
        end
            
        it "Customer fails purchase because item stockQty is 0" do
            
        #1. This is input data for orders_controller
          order = { itemId: 1,                    
                    email: 'dw@csumb.edu' } 
                    
          headers = {"CONTENT_TYPE" => "application/json" ,
                     "ACCEPT" => "application/json"}    
        
        #2. Rspec double for Customer.getCustomerByEmail             
          expect(Customer_Service).to receive(:getCustomerByEmail).with('dw@csumb.edu') do    
            [ 200, {:id => 1, :award => 0 } ]
          end 
        
        #3. Rspec double for Item.getItemById  
           expect(Item_Service).to receive(:getItemById).with(1) do          
            [ 200, { :id => 1, :description => 'jewelry item',
                          :price => 175.00, :stockQty => 0.0 } ]
          end 
                    
          post '/orders', params: order.to_json, headers: headers
          
          expect(response).to have_http_status(200)
          order_json = JSON.parse(response.body)
          expect(order_json).to include( {"error" => "Item is out of stock", "status" => 400} )
          
        end
        
        it "Customer fails purchase because item id is not valid" do
            
        #1. This is input data for orders_controller
          order = { itemId: 100,                    
                    email: 'dw@csumb.edu' } 
                    
          headers = {"CONTENT_TYPE" => "application/json" ,
                     "ACCEPT" => "application/json"}    
        
        #2. Rspec double for Customer.getCustomerByEmail             
          expect(Customer_Service).to receive(:getCustomerByEmail).with('dw@csumb.edu') do    
            [ 200, {:id => 1, :award => 0 } ]
          end 
        
        #3. Rspec double for Item.getItemById  
           expect(Item_Service).to receive(:getItemById).with(100) do          
            [ 400, { } ]
          end 
                    
          post '/orders', params: order.to_json, headers: headers
          
          expect(response).to have_http_status(200)
          order_json = JSON.parse(response.body)
          expect(order_json).to include( {"error" => "Item could not be found", "status" => 400} )
          
        end
        
        it "Customer fails purchase because customer cannot be found" do
            
        #1. This is input data for orders_controller
          order = { itemId: 1,                    
                    email: 'dw@csumb.edu' } 
                    
          headers = {"CONTENT_TYPE" => "application/json" ,
                     "ACCEPT" => "application/json"}    
        
        #2. Rspec double for Customer.getCustomerByEmail             
          expect(Customer_Service).to receive(:getCustomerByEmail).with('dw@csumb.edu') do    
            [ 400, { } ]
          end 
                    
          post '/orders', params: order.to_json, headers: headers
          
          expect(response).to have_http_status(200)
          order_json = JSON.parse(response.body)
          expect(order_json).to include( {"error" => "Customer could not be found. ", "status" => 400} )
          
        end
        
        it "Retrieve Order by customerId" do
          id = 1
          get "/orders?customerId=#{id}", :headers => headers
          expect(response).to have_http_status(200)
        end
        
        it "Retrieve Order by email" do
          email = "ade-la-costa@csumb.edu"
          get "/orders?email=#{email}", :headers => headers
          expect(response).to have_http_status(200)
        end
        
        it "Get Order by Id" do
            
          info = { id: 1}
                    
          headers = {"ACCEPT" => "application/json"}    
                    
          post '/orders/', params: info.to_json, headers: headers
          
          expect(response).to have_http_status(200)
        end
        
        
    end
end