require 'poundpay/resource'

module Poundpay
  class Developer < Resource
    def self.me
      find(self.user)
    end
  end

  class Payment < Resource
    def release
      self.status = 'RELEASED'
      self.save
    end
  end
end