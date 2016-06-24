require 'date'
class StaticPagesController < ApplicationController
  skip_before_filter  :verify_authenticity_token
  def home
        @user = VirtualUser.find_by(user_session: session.id)
        if not @user.present?
                redirect_to '/'
        else
                if @user.build_branch.nil?
                        @qa_suite_today = QaSuite.homepage_qa_suites_today(@user.version, @user.platform, @user.timestamp).all
                        @build_step_today = BuildStep.homepage_build_steps_today(@user.version, @user.platform, @user.timestamp).all
                else
                        @qa_suite_today = QaSuite.homepage_qa_suites_by_branch(@user.version, @user.platform, @user.build_branch)
                        @build_step_today = BuildStep.homepage_build_steps_by_branch(@user.version, @user.platform, @user.build_branch)
                end
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
                        user.build_branch = QaSuite.where("version = ?", user.version).where("platform = ?", params[:platform]).where("suite_name = ?", 'customer').first.branch
                elsif params.keys[2] == 'commit' && params[:commit] == 'Go'
                        user.build_branch = params[:select][:buildname]
                elsif params.keys[1] == 'commit'
                        if params[:commit] == 'Prev'
                                user.timestamp = (user.timestamp.to_datetime - 1.days).to_s
                        elsif params[:commit] == 'Next'
                                user.timestamp = (user.timestamp.to_datetime + 1.days).to_s
                        end
                end

                if user.save!
                        if user.build_branch.nil?
                                @selected_qa_suite_today = QaSuite.homepage_qa_suites_today(user.version, user.platform, user.timestamp).all
                                @selected_build_step_today = BuildStep.homepage_build_steps_today(user.version, user.platform, user.timestamp).all
                        else
                                @selected_qa_suite_today = QaSuite.homepage_qa_suites_by_branch(user.version, user.platform, user.build_branch)
                                @selected_build_step_today = BuildStep.homepage_build_steps_by_branch(user.version, user.platform, user.build_branch)

                        end
                        @selected_user = VirtualUser.find_by(user_session: session.id)
                        respond_to do |format|
                                format.html { redirect_to '/' }
                                format.js   {}
                        end
                end
        end
  end