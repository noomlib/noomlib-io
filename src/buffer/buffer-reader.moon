import type from _G

import BUFFER_MINIMUM_POSITION from "noomlib/io/buffer/constants"
import bytes_from_string, bytes_from_table, string_from_bytes from "noomlib/io/buffer/utilities"

-- BufferReader BufferReader(string or table [bytes], number [position])
-- Represents a simple byte-based readable buffer
export BufferReader = (bytes = nil, position = BUFFER_MINIMUM_POSITION) ->
    if type(bytes) == "string" then bytes = bytes_from_string(bytes)
    elseif type(bytes) == "table" then bytes = bytes_from_table(bytes)
    else error("bad argument #1 to 'BufferReader' (expected string or table)")

    -- table BufferReader::get_buffer()
    -- Returns a clone of the internal buffer
    get_buffer = () ->
        return [byte for byte in *bytes]

    -- string BufferWriter::get_buffer_string()
    -- Returns the string version of the internal buffer
    get_buffer_string = () ->
        slice = get_buffer()

        return string_from_bytes(slice)

    -- number BufferReader::get_position()
    -- Returns the current position of the cursor
    get_position = () ->
        return position

    -- number BufferReader::get_remaining()
    -- Returns the remaining capacity of bytes in the buffer
    get_remaining = () ->
        return #bytes - (position - 1)

    -- number BufferReader::get_size()
    -- Returns the total size of bytes in the buffer
    get_size = () ->
        return #bytes

    -- boolean BufferReader::is_end()
    -- Returns if the current position is at the end of the buffer
    is_end = () ->
        return position >= get_size()

    -- table BufferReader::read(number [length])
    -- Returns the read length of bytes as a table slice, reading the remaining capacity if no length provided
    read = (length = get_remaining()) ->
        if is_end() then error("bad dispatch to 'BufferReader::read' (position at end of buffer)")

        size = get_size()
        if position + length > size then error("bad argument #1 to 'BufferReader::read' (length greater than remaining capacity)")

        next = (position + length) - 1
        slice = [byte for byte in *bytes[position, next]]
        position = position + length

        return slice

    -- string BufferReader::read_string(number [length])
    -- Returns the read length of bytes as a string slice, reading the remaining capacity if no length provided
    read_string = (length) ->
        slice = read(length)

        return string_from_bytes(slice)

    -- void BufferReader::set_position(number cursor)
    -- Updates the current position of the buffer
    set_position = (cursor) ->
        size = get_size()

        if cursor > size then error("bad argument #1 to 'BufferReader::set_position' (cursor greater than buffer)")
        if cursor < BUFFER_MINIMUM_POSITION then error("bad argument #1 to 'BufferReader::set_position' (cursor less than minimum)")

        position = cursor

    set_position(position)

    return {
        :get_buffer,
        :get_buffer_string,
        :get_position,
        :get_remaining,
        :get_size,
        :is_end,
        :read,
        :read_string,
        :set_position
    }