class SimpleApplication
  CONFIG = {
    poundpay: {
      "api_url" => "http://localhost:8000",
      "www_url" => "http://localhost:5000",
      "version" => "silver",
      "developer_sid" => "DV2f8a5168710c11e0aab3123140005921",
      "auth_token" => "f309a5f600a630f7293c64783eaebc8b67a34428cfcd96e82599657a12769924",
      "callback_url" => '',
    },
    default_payment: {
        "amount" => "67890",
        "payer_fee_amount" => "100",
        "recipient_fee_amount" => "200",
        "payer_email_address" => "sam@example.com",
        "recipient_email_address" => "jacob@example.net",
        "description" => "this is a simple description that just loves developers, developers",
    }
  }
end