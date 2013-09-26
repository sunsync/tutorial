module Moat

  REST_URI = "https://cloud.service-sync.com"
  REST_PATH = "/moat/v1"
  PACKAGE_ID = "blink-rgx-led"
  OPERATION = "blink-rgx-led"
  OPERATION_VERSION = "1.0"

  APPLICATION_ID = "<Your Applicaltion ID>"
  API_CLIENT_ID = "<Your Client ID>"
  API_CLIENT_SECRET = "<Your Client Secret>"

  BLINK_RGX_LED = "urn:moat:#{APPLICATION_ID}:#{PACKAGE_ID}:#{OPERATION}:#{OPERATION_VERSION}"

end
