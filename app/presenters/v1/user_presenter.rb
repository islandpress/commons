module V1
  class UserPresenter < Yumi::Base
    type 'user'
    attributes :email, :first_name, :last_name
    links :self
  end
end
