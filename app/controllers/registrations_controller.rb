# Overriden specifically for the use of the captcha
# See https://github.com/plataformatec/devise/wiki/How-To:-Use-Recaptcha-with-Devise
class RegistrationsController < Devise::RegistrationsController
    def create
      super
      #if verify_recaptcha
      #  super
      #else
      #  flash.delete(:recaptcha_error)
      #  build_resource
      #  clean_up_passwords(resource)
      #  flash[:alert] = "There was an error with the recaptcha code below. Please re-enter the code."
      #  
      #  render 'devise/registrations/new'
      #end
    end
end
