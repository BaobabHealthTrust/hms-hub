class AddRoleToUsers < ActiveRecord::Migration
  class User < ActiveRecord::Base
    self.table_name = 'users'
  end

  def up
    add_column :users, :role, :string

    User.scoped.each {|u| u.update_attributes(:role => 'superadmin') }
  end

  def down
    remove_column :users, :role
  end

end
