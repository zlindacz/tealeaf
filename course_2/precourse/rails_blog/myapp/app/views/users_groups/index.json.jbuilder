json.array!(@users_groups) do |users_group|
  json.extract! users_group, :id
  json.url users_group_url(users_group, format: :json)
end
