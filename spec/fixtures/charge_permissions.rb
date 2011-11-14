module Poundpay
  module ChargePermissionFixture
    def created_attributes
      {
        "email_address"              => "john@example.com",
        "state"                      => "CREATED",
        "updated_at"                 => "2011-02-11T19:07:05.332356Z",
        "created_at"                 => "2011-02-11T19:07:05.332356Z",
      }
    end

    def active_attributes
      @attributes = created_attributes
      @attributes["state"] = "ACTIVE"
      @attributes
    end

    def inactive_attributes
      @attributes = created_attributes
      @attributes["state"] = "INACTIVE"
      @attributes
    end
  end
end
