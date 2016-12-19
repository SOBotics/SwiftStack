#!/bin/bash

echo "Generating library..."
swiftc -emit-library -emit-object -module-name SwiftStack Sources/*.swift || exit 1
ar rcs libSwiftStack.a *.o || exit 1
rm *.o

echo "Generating swiftmodule..."
swiftc -emit-module -module-name SwiftStack Sources/*.swift || exit 1
