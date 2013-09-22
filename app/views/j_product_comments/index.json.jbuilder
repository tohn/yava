json.array!(@j_product_comments) do |j_product_comment|
  json.extract! j_product_comment, :comment_id, :product_id
  json.url j_product_comment_url(j_product_comment, format: :json)
end