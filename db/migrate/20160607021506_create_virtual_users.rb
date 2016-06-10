class CreateVirtualUsers < ActiveRecord::Migration
  def change
    create_table :virtual_users do |t|
      t.string :user_name
      t.string :user_session
      t.string :version, default: 'master'
      t.string :platform, default: 'linux_x86_64_rhel6'
      t.string :timestamp, default: 'today'

      t.timestamps null: false
    end
    add_index :virtual_users, [:user_name, :user_session]
  end
end
