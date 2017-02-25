class Users::RegistrationsController < Devise::RegistrationsController
  def build_resource(hash=nil)
    hash[:uid] = User.create_unique_string
    super
  end
  def edit
    if resource.email.include?("example")
      resource.email = ""
    end
  end
end
