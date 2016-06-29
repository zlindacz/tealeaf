class AddUserIdToGroupsUsers < ActiveRecord::Migration
  def change
    add_column :groups_users, :user_id, :integer
  end
end
