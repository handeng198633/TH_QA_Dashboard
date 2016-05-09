class StaticPagesController < ApplicationController

  def home
  	@qa_suite_today = QaSuite.homepage_qa_suites_today.all
  	@qa_suite_yesterday = QaSuite.homepage_qa_suites_yesterday.all
  end
end