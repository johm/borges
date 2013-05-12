require 'machinist/active_record'

# Add your blueprints here.
#
# e.g.
#   Post.blueprint do
#     title { "Post #{sn}" }
#     body  { "Lorem ipsum..." }
#   end

User.blueprint do
  # Attributes here
end

Author.blueprint do
  # Attributes here
end

Title.blueprint do
  # Attributes here
end

Contribution.blueprint do
  # Attributes here
end

Edition.blueprint do
  # Attributes here
end

Copy.blueprint do
  # Attributes here
end

PurchaseOrder.blueprint do
  # Attributes here
end

PurchaseOrderLineItem.blueprint do
  # Attributes here
end

Invoice.blueprint do
  # Attributes here
end

InvoiceLineItem.blueprint do
  # Attributes here
end

Distributor.blueprint do
  # Attributes here
end
