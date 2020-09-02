package = "kong-plugin-isagri-idtranslate"
version = "0.0.1-0"

source = {
  url = "git://github.com/Kong/kong-plugin-isagri-idtranslate",
  tag = "0.0.1"
}

supported_platforms = {"linux", "macosx", "win32"}
description = {
  summary = "Kong Isagri Translate Id Plugin",
  license = "Apache 2.0",
}

build = {
  type = "builtin",
  modules = {
    ["kong.plugins.isagri-idtranslate.migrations.cassandra"] = "kong/plugins/isagri-idtranslate/migrations/cassandra.lua",
    ["kong.plugins.isagri-idtranslate.migrations.postgres"] = "kong/plugins/isagri-idtranslate/migrations/postgres.lua",
    ["kong.plugins.isagri-idtranslater.migrations.common"] = "kong/plugins/isagri-idtranslate/migrations/common.lua",
    ["kong.plugins.isagri-idtranslate.handler"] = "kong/plugins/isagri-idtranslate/handler.lua",
    ["kong.plugins.isagri-idtranslate.access"] = "kong/plugins/isagri-idtranslate/access.lua",
    ["kong.plugins.isagri-idtranslate.schema"] = "kong/plugins/isagri-idtranslate/schema.lua",
  }
}
