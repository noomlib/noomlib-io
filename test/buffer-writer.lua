local noomlib_io = require("../dist/noomlib_io.lua")

local CONTROL_BYTES = {116, 104, 105, 115, 32, 105, 115, 32, 97, 32, 116, 101, 115, 116, 32, 115, 116, 114, 105, 110, 103}

local CONTROL_STRING = "this is a test string"

return function (describe, expect, it)
    it("BufferWriter() - default", function ()
        buffer = noomlib_io.BufferWriter()

        expect(buffer.get_size()).to.equal(4096)
    end)

    it("BufferWriter(number) - custom", function ()
        buffer = noomlib_io.BufferWriter(10000)

        expect(buffer.get_size()).to.equal(10000)

        for index, value in ipairs(buffer.get_buffer(false)) do
            if value ~= -1 then
                error("preallocation failed")
            end
        end
    end)

    it("BufferWriter(table) - control bytes", function ()
        buffer = noomlib_io.BufferWriter(CONTROL_BYTES)

        expect(buffer.get_buffer()).to.equal(CONTROL_BYTES)
    end)

    it("BufferWriter(string) - control string", function ()
        buffer = noomlib_io.BufferWriter(CONTROL_STRING)

        expect(buffer.get_buffer_string()).to.equal(CONTROL_STRING)
    end)

    it("BufferWriter::write(table) - control bytes", function ()
        buffer = noomlib_io.BufferWriter()

        buffer.write(CONTROL_BYTES)
        expect(buffer.get_buffer()).to.equal(CONTROL_BYTES)
    end)

    it("BufferWriter::write_string(string) - control string", function ()
        buffer = noomlib_io.BufferWriter()

        buffer.write_string(CONTROL_STRING)
        expect(buffer.get_buffer_string()).to.equal(CONTROL_STRING)
    end)

    it("BufferWriter::write_string(string) - control string fixed", function ()
        buffer = noomlib_io.BufferWriter(CONTROL_STRING, #CONTROL_STRING, true)

        expect(function ()
            buffer.write_string("hello!")
        end).to.fail()
    end)
end