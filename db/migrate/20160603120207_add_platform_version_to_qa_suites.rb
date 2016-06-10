class AddPlatformVersionToQaSuites < ActiveRecord::Migration
  def change
    add_column :qa_suites, :version, :string, default: 'master'
    add_column :qa_suites, :platform, :string, default: 'linux_x86_64_rhel6'
  end
end
