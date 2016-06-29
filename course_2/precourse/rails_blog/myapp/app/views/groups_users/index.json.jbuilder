json.array!(@groups_users) do |groups_user|
  json.extract! groups_user, :id
  json.url groups_user_url(groups_user, format: :json)
end
