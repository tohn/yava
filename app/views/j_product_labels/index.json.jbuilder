json.array!(@j_product_labels) do |j_product_label|
  json.extract! j_product_label, :product_id, :label_id, :user_id
  json.url j_product_label_url(j_product_label, format: :json)
end