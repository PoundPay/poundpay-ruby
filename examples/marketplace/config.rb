class SimpleApplication
  CONFIG = {
    poundpay: {
      "api_url" => "https://api-sandbox.poundpay.com",
      "www_url" => "https://www-sandbox.poundpay.com",
      "version" => "silver",
      "developer_sid" => "DVxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx",
      "auth_token" => "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx",
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