'use strict'


config =
  app_port: 50000
  session_secret: 'THIS_IS_MY_SECRET_TOKEN_YEEHAW'


switch process.env.NODE_ENV
  # Development
  when 'development'
    config.app_port = 50000

  # Staging
  when 'staging'
    config.app_port = 50000

  # Production
  else
    config.app_port = 50000


exports.config = config
