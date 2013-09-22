json.array!(@j_product_inquiries) do |j_product_inquiry|
  json.extract! j_product_inquiry, :inquiry_id, :product_id
  json.url j_product_inquiry_url(j_product_inquiry, format: :json)
end