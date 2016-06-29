json.array!(@posts) do |post|
  json.extract! post, :id, :user_name, :title, :article
  json.url post_url(post, format: :json)
end
