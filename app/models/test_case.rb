class TestCase < ActiveRecord::Base
	belongs_to :qa_suite
	has_one :log
end
