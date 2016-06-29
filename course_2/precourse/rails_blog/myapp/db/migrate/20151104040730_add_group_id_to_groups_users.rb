class AddGroupIdToGroupsUsers < ActiveRecord::Migration
  def change
    add_column :groups_users, :group_id, :integer
  end
end
