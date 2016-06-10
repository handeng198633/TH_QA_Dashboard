class StaticPagesController < ApplicationController
  skip_before_filter  :verify_authenticity_token
  def home
        user = VirtualUser.find_by(user_session: session.id)
        if user
                @qa_suite_today = QaSuite.homepage_qa_suites_today(user.version, user.platform, user.timestamp).all
        else
                @qa_suite_today = QaSuite.homepage_qa_suites_today('master', 'linux_x86_64_rhel6').all
        end
        #respond_to do |format|
        #       format.html { redirect_to root_url }
        #       format.js
        #end
        #@qa_suite_yesterday = QaSuite.homepage_qa_suites_yesterday.all
        #@build_step_yesterday = BuildStep.homepage_build_steps_yesterday.all
  end

  def select
        user = VirtualUser.find_by(user_session: session.id)
        if user
                if params.keys[0] == 'version'
                        user.version = params[:version]
                elsif params.keys[0] == 'platform'
                        user.platform = params[:platform]
                elsif params.keys[1] == 'commit'
                        if params[:commit] == 'Prev'
                                user.timestamp = (user.timestamp.to_datetime - 1.days).to_s
                        elsif params[:commit] == 'Next'
                                user.timestamp = (user.timestamp.to_datetime + 1.days).to_s
                        end
                end
                if user.save!
                        respond_to do |format|
                                format.html { redirect_to '/homepage' }
                                format.js
                        end
                end
        end
  end

  def rhel5
        @qa_suite_today = QaSuite.homepage_qa_suites_today_rhel5.all
        @qa_suite_yesterday = QaSuite.homepage_qa_suites_yesterday_rhel5.all
        @build_step_today = BuildStep.homepage_build_steps_today_rhel5.all
        @build_step_yesterday = BuildStep.homepage_build_steps_yesterday_rhel5.all
  end 
             
end