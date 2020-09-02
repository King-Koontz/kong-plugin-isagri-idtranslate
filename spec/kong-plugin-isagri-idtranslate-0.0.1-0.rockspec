package = "kong-plugin-isagri-idtranslate"
version = "0.0.1-0"

source = {
  url = "git://github.com/King-Koontz/kong-plugin-isagri-idtranslate",
  tag = "0.0.1"
}

supported_platforms = {"linux", "macosx"}
description = {
  summary = "Kong Isagri Translate Id Plugin",
  license = "Apache 2.0",
}

build = {
  type = "builtin",
  modules = {
    ["kong.plugins.request-transformer.migrations.cassandra"] = "kong/plugins/request-transformer/migrations/cassandra.lua",
    ["kong.plugins.request-transformer.migrations.postgres"] = "kong/plugins/request-transformer/migrations/postgres.lua",
    ["kong.plugins.request-transformer.migrations.common"] = "kong/plugins/request-transformer/migrations/common.lua",
    ["kong.plugins.request-transformer.handler"] = "kong/plugins/request-transformer/handler.lua",
    ["kong.plugins.request-transformer.access"] = "kong/plugins/request-transformer/access.lua",
    ["kong.plugins.request-transformer.schema"] = "kong/plugins/request-transformer/schema.lua",
  }
}
