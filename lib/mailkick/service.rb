module Mailkick
  class Service

    def fetch_opt_outs
      opt_outs.each do |api_data|
        email = api_data[:email]
        time = api_data[:time]

        opt_out = Mailkick::OptOut.where(email: email).order("updated_at desc").first
        if !opt_out or (time > opt_out.updated_at and !opt_out.active)
          Mailkick::OptOut.create! do |o|
            o.email = email
            o.user = Mailkick.user_method if Mailkick.user_method.call(email)
            o.reason = api_data[:reason]
            o.created_at = time
            o.updated_at = time
          end
        end
      end
      true
    end

  end
end