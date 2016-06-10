class VirtualUsersController < ApplicationController
  def new
    @virtual_user = VirtualUser.new
  end

  def create
    if VirtualUser.find_by(user_session: session.id).nil?
      @virtual_user = VirtualUser.new
      @virtual_user.user_name = Time.now.to_formatted_s(:number)
      @virtual_user.user_session = session.id
      @virtual_user.timestamp = Date.today.to_s
      if @virtual_user.save!
        redirect_to '/homepage'
      end
   else
     redirect_to '/homepage'
   end
  end
end
