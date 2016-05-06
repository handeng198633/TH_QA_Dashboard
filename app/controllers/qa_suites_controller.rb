class QaSuitesController < ApplicationController
	def new
		@qa_suite = QaSuite.new
	end

	def show
		@qa_suite = QaSuite.find(params[:id])
	end

	def index
	 	@qa_suites = QaSuite.paginate(page: params[:page],:per_page => 4)
	end

	def import
		QaSuite.import(params[:file]) 
	 	redirect_to qa_suites_url, notice: "Log file imported."
	end 
end