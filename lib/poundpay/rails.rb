if defined? Rails
  require 'erb'

  module Poundpay
    def self.configure_from_yaml(path)
      pathname = Rails.root.join(path)
      raise ArgumentError, "File does not exist: #{pathname}" unless pathname.exist?

      config = pathname.read
      config = ERB.new(config).result if pathname.extname == '.erb'
      config = YAML.load(config)[Rails.env]

      Poundpay.configure_from_hash(config)
    end
  end
end
