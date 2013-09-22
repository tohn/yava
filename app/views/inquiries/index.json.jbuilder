json.array!(@inquiries) do |inquiry|
  json.extract! inquiry, :type, :text, :user_id, :highlight, :veganity_id
  json.url inquiry_url(inquiry, format: :json)
end