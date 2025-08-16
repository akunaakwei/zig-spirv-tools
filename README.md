# SPIRV-Tools
This is SPIRV-Tools packaged for the Zig build system.

# generating code
SPIRV-Tools generates some code with python. These files are pregenerated and live in the `include` directory, so depending on this package does not require a python installation.  
After updating the upstream, you should regenrate the code. This commands requires a `python3` executable in path.
```bash
zig build gen
```