class QaSuite < ActiveRecord::Base
	has_many :test_cases

	def self.import(file)
		script = String.new
		qa_suite_hash = Hash.new
		script = "#{Rails.root}/public/log2data.rb"
		qa_suite_hash =`ruby #{script} #{file}`
#		suite_hash, cases_index = `ruby #{script} #{file}`
		QaSuite.create! qa_suite_hash
	end
end
