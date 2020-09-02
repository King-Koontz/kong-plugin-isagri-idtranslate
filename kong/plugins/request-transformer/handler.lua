local access = require "kong.plugins.request-transformer.access"


local IsagriIdTranslateHandler = {
  VERSION  = "0.0.01",
  PRIORITY = 801,
}


function IsagriIdTranslateHandler:access(conf)
  access.execute(conf)
end


return IsagriIdTranslateHandler
