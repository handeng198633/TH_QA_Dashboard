class AddCaseIdToLogs < ActiveRecord::Migration
  def change
    add_column :logs, :case_id, :integer
  end
end
