class LogsController < ApplicationController
	def show
		@log = Log.new
		@test_case = TestCase.find(params[:id])
		respond_to do |format|
			format.html { render @log }
	        format.js
	    end
	end
end