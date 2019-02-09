import unpack, type from _G
import byte, char from string

import BYTE_MAXIMUM_VALUE, BYTE_MINIMUM_VALUE from "noomlib/io/buffer/constants"

-- table allocate(number size)
-- Returns a preallocated table
export allocate = (size) ->
    return [-1 for _=1, size]

-- table bytes_from_string(string string)
-- Returns a table of bytes from a string
export bytes_from_string = (string) ->
    return {byte(string, index, #string)}

-- table bytes_from_table(table table)
-- Returns a table of bytes from a string table
-- ```lua
-- local tbl = {"he", "l", "l", "o"}
-- local bytes = bytes_from_table(tbl) -- `{104, 101, 108, 108, 111}`
-- ```
export bytes_from_table = (table) ->
    bytes = {}

    for _byte in *table
        if type(_byte) == "string"
            for index = 1, #_byte
                bytes[#bytes + 1] = byte(_byte, index, index)

        elseif type(_byte) == "number"
            if _byte >= BYTE_MINIMUM_VALUE and _byte <= BYTE_MAXIMUM_VALUE then bytes[#bytes + 1] = _byte
            else error("bad argument #1 'bytes_from_table' (expected ranged number values of 0...255 in table")

        else error("bad argument #1 to 'bytes_from_table' (expected number or string values in table)")

    return bytes

-- string string_from_bytes(table bytes)
-- Returns a constructed string from a table of bytes
-- ```lua
-- local bytes = {104, 101, 108, 108, 111}
-- local string = string_from_bytes(bytes) -- `hello`
-- ```
export string_from_bytes = (bytes) ->
    return char(unpack(bytes))