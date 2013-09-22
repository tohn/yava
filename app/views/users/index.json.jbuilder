json.array!(@users) do |user|
  json.extract! user, :provider_id, :nickname, :lastlogin, :points
  json.url user_url(user, format: :json)
end