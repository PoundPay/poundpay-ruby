module Poundpay
  module PaymentFixture
    def created_payment_attributes
      {
        "amount"                     => 20000,
        "payer_fee_amount"           => 0,
        "payer_email_address"        => "goliath@example.com",
        "recipient_fee_amount"       => 500,
        "recipient_email_address"    => "david@example.com",
        "description"                => "Beats by Dr. Dre",
        "sid"                        => "PY1d82752a361211e0bce31231400042c7",
        "status"                     => "STAGED",
        "amount_to_credit_developer" => 550,
        "updated_at"                 => "2011-02-11T19:07:05.332356Z",
        "recipient_sid"              => nil,
        "payer_sid"                  => nil,
        "developer_sid"              => "DV8539761e250011e0a81d1231400042c7",
        "poundpay_fee_amount"        => 450,
        "created_at"                 => "2011-02-11T19:07:05.332356Z",
        "amount_to_credit_recipient" => 19500,
        "amount_to_charge_payer"     => 20000,
      }
    end

    def escrowed_payment_attributes
      {
        "amount"                     => 20000,
        "payer_fee_amount"           => 0,
        "payer_email_address"        => "goliath@example.com",
        "recipient_fee_amount"       => 500,
        "recipient_email_address"    => "david@example.com",
        "description"                => "Beats by Dr. Dre",
        "sid"                        => "PY1d82752a361211e0bce31231400042c7",
        "status"                     => "ESCROWED",
        "amount_to_credit_developer" => 550,
        "updated_at"                 => "2011-02-11T19:07:05.332356Z",
        "recipient_sid"              => nil,
        "payer_sid"                  => "US552595ee364111e0b18800264a09ff3c",
        "developer_sid"              => "DV8539761e250011e0a81d1231400042c7",
        "poundpay_fee_amount"        => 450,
        "created_at"                 => "2011-02-11T19:07:05.332356Z",
        "amount_to_credit_recipient" => 19500,
        "amount_to_charge_payer"     => 20000,
      }
    end

    def released_payment_attributes
      {
        "amount"                     => 20000,
        "payer_fee_amount"           => 0,
        "payer_email_address"        => "goliath@example.com",
        "recipient_fee_amount"       => 500,
        "recipient_email_address"    => "david@example.com",
        "description"                => "Beats by Dr. Dre",
        "sid"                        => "PY1d82752a361211e0bce31231400042c7",
        "status"                     => "RELEASED",
        "amount_to_credit_developer" => 550,
        "updated_at"                 => "2011-02-11T19:07:05.332356Z",
        "recipient_sid"              => nil,
        "payer_sid"                  => "US552595ee364111e0b18800264a09ff3c",
        "developer_sid"              => "DV8539761e250011e0a81d1231400042c7",
        "poundpay_fee_amount"        => 450,
        "created_at"                 => "2011-02-11T19:07:05.332356Z",
        "amount_to_credit_recipient" => 19500,
        "amount_to_charge_payer"     => 20000,
      }
    end
  end
end