class AddLogfileDateToQaSuites < ActiveRecord::Migration
  def change
    add_column :qa_suites, :date, :string
    add_column :qa_suites, :log_file, :string
  end
end
