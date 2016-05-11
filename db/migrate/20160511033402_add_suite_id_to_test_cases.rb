class AddSuiteIdToTestCases < ActiveRecord::Migration
  def change
    add_column :test_cases, :suite_id, :integer
  end
end
