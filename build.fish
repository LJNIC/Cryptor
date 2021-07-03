#!/usr/bin/fish
set FILES src/util.rkt src/vector.rkt src/config.rkt src/cryptor.rkt
cat build/cel7 $FILES > build/Cryptor
cat build/cel7.exe $FILES > build/Cryptor.exe

switch $argv[1]
    case -r
        cd build && ./Cryptor
end

