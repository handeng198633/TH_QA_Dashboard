class CreateQaSuites < ActiveRecord::Migration
  def change
    create_table :qa_suites do |t|
      t.string :suite_name, default: 'NULL'
      t.string :branch, default: 'NULL'
      t.datetime :start_time
      t.datetime :end_time
      #t.datetime :date
      t.string :build_type, default: 'NULL'
      t.string :command_line, default: 'NULL'
      t.string :executable, default: 'NULL'
      t.string :host, default: 'NULL'
      t.string :display, default: 'NULL'
      t.string :pid, default: 'NULL'
      #t.string :log_file, default: 'NULL'
      t.text :failed_info, default: 'NULL'
      t.text :diffs_info, default: 'NULL'
      t.text :asserts_info, default: 'NULL'
      t.text :warnings_info, default: 'NULL'
      t.text :status, default: 'NULL'
      t.integer :pass_number, default: 0
      t.integer :failed_numnber, default: 0

      t.timestamps null: false
    end
  end
end
