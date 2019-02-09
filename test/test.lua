local lust = require("./lust.lua")

local describe, expect, it = lust.describe, lust.expect, lust.it

describe("noomlib/io/buffer/buffer-reader", function ()
    require("./buffer-reader.lua")(describe, expect, it)
end)

describe("noomlib/io/buffer/buffer-writer", function ()
    require("./buffer-writer.lua")(describe, expect, it)
end)