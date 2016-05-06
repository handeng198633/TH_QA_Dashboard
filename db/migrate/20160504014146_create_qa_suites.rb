class CreateQaSuites < ActiveRecord::Migration
  def change
    create_table :qa_suites do |t|
      t.string :suite_name
      t.string :branch
      t.datetime :start_time
      t.datetime :end_time
      t.string :build_type
      t.string :command_line
      t.string :executable
      t.string :host
      t.string :display
      t.string :pid
      t.text :failed_info
      t.text :diffs_info
      t.text :asserts_info
      t.text :warnings_info
      t.text :status
      t.integer :pass_number
      t.integer :failed_numnber

      t.timestamps null: false
    end
  end
end
