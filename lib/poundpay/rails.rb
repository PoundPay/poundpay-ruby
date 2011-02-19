if defined? Rails and Rails.root.join("config", "poundpay.yml").exist?
  module Poundpay
    @rails_config = YAML::load_file(Rails.root.join("config", "poundpay.yml"))[Rails.env]
    Poundpay.configure_from_hash(@rails_config)
  end
end