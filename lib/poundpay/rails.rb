if defined? Rails
  module Poundpay
    def self.configure_from_yaml(path)
      pathname = Pathname.new Rails.root.join(path)
      raise ArgumentError.new "File does not exist: #{pathname.to_s}" unless pathname.exist?
      config = YAML::load(ERB.new(File.read(pathname)).result)[Rails.env]
      Poundpay.configure_from_hash(config)
    end
  end
end
