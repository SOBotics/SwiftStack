#!/bin/bash

echo "Generating library..."
swiftc -emit-library -emit-object -module-name SwiftChatSE Sources/*.swift || exit 1
ar rcs libSwiftChatSE.a *.o || exit 1
rm *.o

echo "Generating swiftmodule..."
swiftc -emit-module -module-name SwiftChatSE Sources/*.swift || exit 1
