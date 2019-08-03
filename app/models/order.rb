class Order < ApplicationRecord
    # An order has to have an itemId and a customerId associated to it.
    validates :itemId,
            presence: true
    validates :customerId,
            presence: true
end
