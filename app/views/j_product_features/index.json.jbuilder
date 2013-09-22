json.array!(@j_product_features) do |j_product_feature|
  json.extract! j_product_feature, :product_id, :feature_id, :user_id
  json.url j_product_feature_url(j_product_feature, format: :json)
end