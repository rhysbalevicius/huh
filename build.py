#!/usr/bin/env python
import binascii, os, sys

def main():
    print "Compiling wo.wat to wo.wasm ..."

    file_in = "wo.wasm"
    file_out = "main.wasm.js"

    wasm = os.system("~/wabt/wat2wasm wo.wat")

    if wasm == 0:
        print "Hexdump wo.wasm into main.wasm.js ..."
        if os.path.exists(file_in):
            with open(file_in, "rb") as f_in:
                hex = binascii.hexlify(f_in.read())
            hexc = len(hex)
            with open(file_out, "w") as f_out:
                i = 0
                f_out.write("const main = [\n\t")
                while i < hexc:
                    b = "0x"+hex[i:i+2]
                    i += 2
                    if i < hexc:
                        b += ", "
                    f_out.write(b)
                    if i % 32 == 0:
                        f_out.write("\n\t")
                f_out.write("\n];\n")
            print "Cleaning up wo.wasm ..."
            os.system("rm wo.wasm")
    else:
        print "Compilation with wat2wasm failed"

main()
