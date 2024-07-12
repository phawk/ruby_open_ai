class PagesController < ApplicationController
  skip_before_action :authenticate

  def home
    @conversation = Current.user.conversations.first_or_create!
  end
end
