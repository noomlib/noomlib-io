import type from _G

import BUFFER_DEFAULT_SIZE, BUFFER_MINIMUM_POSITION from "noomlib/io/buffer/constants"
import allocate, bytes_from_string, bytes_from_table, string_from_bytes from "noomlib/io/buffer/utilities"

-- BufferWriter BufferWriter(number or string or table [bytes], number [position], boolean [fixed])
-- Represents a simple byte-based writable buffer
export BufferWriter = (bytes = BUFFER_DEFAULT_SIZE, position = BUFFER_MINIMUM_POSITION, fixed = false) ->
    if type(bytes) == "number"
        if bytes < 0 then bytes = BUFFER_DEFAULT_SIZE

        bytes = allocate(bytes)

    elseif type(bytes) == "string" then bytes = bytes_from_string(bytes)
    elseif type(bytes) == "table" then bytes = bytes_from_table(bytes)
    else error("bad argument #1 to 'BufferWriter' (expected number, string, or table")

    -- table BufferWriter::get_buffer()
    -- Returns a clone of the internal buffer
    get_buffer = () ->
        slice = {}

        for byte in *bytes
            if byte < 0 then break

            slice[#slice + 1] = byte

        return slice

    -- string BufferWriter::get_buffer_string()
    -- Returns the string version of the internal buffer
    get_buffer_string = () ->
        slice = get_buffer()

        return string_from_bytes(slice)

    -- number BufferWriter::get_position()
    -- Returns the current position of the cursor
    get_position = () ->
        return position

    -- number BufferWriter::get_remaining()
    -- Returns the remaining capacity of bytes in the buffer
    get_remaining = () ->
        return #bytes - (position - 1)

    -- number BufferWriter::get_size()
    -- Returns the total size of bytes in the buffer
    get_size = () ->
        return #bytes

    -- boolean BufferWriter::is_end()
    -- Returns if the current position is at the end of the buffer
    is_end = () ->
        return position >= get_size()

    -- void BufferWriter::set_position(number cursor)
    -- Updates the current position of the buffer
    set_position = (cursor) ->
        size = get_size()

        if cursor > size then error("bad argument #1 to 'BufferWriter::set_position' (cursor greater than buffer)")
        if cursor < BUFFER_MINIMUM_POSITION then error("bad argument #1 to 'BufferWriter::set_position' (cursor less than minimum)")

        position = cursor

    -- void BufferWriter::write(table slice)
    -- Writes a slice of bytes into the buffer
    write = (slice) ->
        if fixed
            next = position + #slice
            if next > get_size() then error("bad argument #1 to 'BufferWriter::write' (buffer cannot allocate more size)")

        for byte in *slice
            bytes[position] = byte
            position = position + 1

    -- void BufferWriter::write_string(string string)
    -- Writes a string as a slice of bytes into the buffer
    write_string = (string) ->
        slice = bytes_from_string(string)

        write(slice)

    set_position(position)

    return {
        :get_buffer,
        :get_buffer_string,
        :get_position,
        :get_remaining,
        :get_size,
        :is_end,
        :set_position,
        :write,
        :write_string
    }