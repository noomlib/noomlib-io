import type from _G
import byte from string

import BUFFER_DEFAULT_SIZE, BUFFER_MINIMUM_POSITION from "noomlib/io/buffer/constants"
import allocate, bytes_from_string, bytes_from_table, in_byte_range, string_from_bytes from "noomlib/io/buffer/utilities"

-- BufferWriter BufferWriter(number or string or table [bytes], number [position], boolean [fixed])
-- Represents a simple byte-based writable buffer
export BufferWriter = (bytes = BUFFER_DEFAULT_SIZE, position = BUFFER_MINIMUM_POSITION, fixed = false) ->
    switch type(bytes)
        when "number"
            if bytes < 0 then bytes = BUFFER_DEFAULT_SIZE

            bytes = allocate(bytes)

        when "string" then bytes = bytes_from_string(bytes)
        when "table" then bytes = bytes_from_table(bytes)
        else error("bad argument #1 to 'BufferWriter' (expected number, string, or table")

    closed = false
    size = #bytes

    -- void check_closed(string member)
    -- Throws an error if the buffer is closed
    check_closed = (member) ->
        if closed then error("bad dispatch '#{member}' (buffer is closed)")

    -- void BufferWriter::close()
    -- Closes the buffer to prevent modification
    close = () ->
        closed = true

    -- table BufferWriter::get_buffer(boolean only_valid)
    -- Returns a clone of the internal buffer, optionally returning the set bytes
    get_buffer = (only_valid = true) ->
        unless only_valid then return [byte for byte in *bytes]

        slice = {}

        for byte in *bytes
            if byte < 0 then break

            slice[#slice + 1] = byte

        return slice

    -- string BufferWriter::get_buffer_string(boolean only_valid)
    -- Returns the string version of the internal buffer
    get_buffer_string = (only_valid = true) ->
        local slice
        if only_valid then slice = get_buffer(true)
        else slice = bytes

        return string_from_bytes(slice)

    -- number BufferWriter::get_position()
    -- Returns the current position of the cursor
    get_position = () ->
        return position

    -- number BufferWriter::get_remaining()
    -- Returns the remaining capacity of bytes in the buffer
    get_remaining = () ->
        return size - (position - 1)

    -- number BufferWriter::get_size()
    -- Returns the total size of bytes in the buffer
    get_size = () ->
        return size

    -- boolean BufferWriter::is_closed()
    -- Returns if the buffer is closed
    is_closed = () ->
        return closed

    -- boolean BufferWriter::is_end()
    -- Returns if the current position is at the end of the buffer
    is_end = () ->
        return position >= size

    -- void BufferWriter::set_position(number cursor)
    -- Updates the current position of the buffer
    set_position = (cursor) ->
        if closed then error("bad dispatch to 'set_position' (buffer is closed)")

        if cursor > size then error("bad argument #1 to 'BufferWriter::set_position' (cursor greater than buffer)")
        if cursor < BUFFER_MINIMUM_POSITION then error("bad argument #1 to 'BufferWriter::set_position' (cursor less than minimum)")

        position = cursor

    -- void BufferWriter::write(number or table slice)
    -- Writes a slice of bytes into the buffer
    write = (slice) ->
        if closed then error("bad dispatch to 'write' (buffer is closed)")

        if type(slice) == "number" then slice = {slice}
        elseif type(slice) ~= "table" then error("bad argument #1 to 'BufferWrite::write' (expected number or table)")

        for byte in *slice
            if type(byte) ~= "number" then error("bad argument #1 to 'BufferWriter::write' (expected number values in table)")
            unless in_byte_range(byte) then error("bad argument #1 'BufferWriter::write' (expected ranged number values of 0...255 in table)")

        slice_length = #slice
        if fixed and (position + slice_length) > size
            error("bad argument #1 to 'BufferWriter::write' (buffer cannot allocate more size)")

        for byte in *slice
            bytes[position] = byte
            position = position + 1

        size = #bytes

    -- void BufferWriter::write_string(string string)
    -- Writes a string as a slice of bytes into the buffer
    write_string = (string) ->
        if closed then error("bad dispatch to 'write_string' (buffer is closed)")

        unless type(string) == "string" then error("bad argument #1 to 'BufferWriter::write_string' (expected string)")

        string_length = #string
        if fixed and (position + string_length) > size
            error("bad argument #1 to 'BufferWriter::write_string' (buffer cannot allocate more size)")

        for index = 1, string_length
            bytes[position] = byte(string, index, index)
            position = position + 1

        size = #bytes

    if position > 0 and size > 0 then set_position(position)
    else position = 1

    return {
        :close,
        :get_buffer,
        :get_buffer_string,
        :get_position,
        :get_remaining,
        :get_size,
        :is_closed,
        :is_end,
        :set_position,
        :write,
        :write_string
    }