class CreateTestCases < ActiveRecord::Migration
  def change
    create_table :test_cases do |t|
      t.string :case_name
      t.string :suite_name
      t.string :group
      t.string :branch
      t.string :host
      t.string :status   
      t.datetime :s_time
      t.datetime :e_time
      t.string :build_type
      t.string :work_path
      t.string :diff_file_path
      t.string :qa_log_path

      t.timestamps null: false
    end
    add_index :test_cases, [:case_name, :created_at]
  end
end
