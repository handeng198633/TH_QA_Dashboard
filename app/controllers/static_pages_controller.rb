class StaticPagesController < ApplicationController
  skip_before_filter  :verify_authenticity_token
  def home
        if params[:version].nil? || params[:platform].nil?
                @qa_suite_today = QaSuite.homepage_qa_suites_today('master', 'linux_x86_64_rhel6').all
        else
                @qa_suite_today = QaSuite.homepage_qa_suites_today(params[:version], params[:platform]).all
        end
        #respond_to do |format|
        #       format.html { redirect_to root_url }
        #       format.js
        #end
        @qa_suite_yesterday = QaSuite.homepage_qa_suites_yesterday.all
        @build_step_today = BuildStep.homepage_build_steps_today.all
        @build_step_yesterday = BuildStep.homepage_build_steps_yesterday.all
  end


  def rhel5
        @qa_suite_today = QaSuite.homepage_qa_suites_today_rhel5.all
        @qa_suite_yesterday = QaSuite.homepage_qa_suites_yesterday_rhel5.all
        @build_step_today = BuildStep.homepage_build_steps_today_rhel5.all
        @build_step_yesterday = BuildStep.homepage_build_steps_yesterday_rhel5.all
  end 
             
end