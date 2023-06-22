// Copyright 2023 Xanadu Quantum Technologies Inc.

// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at

//     http://www.apache.org/licenses/LICENSE-2.0

// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

#ifndef QUANTUM_PASSES
#define QUANTUM_PASSES

include "mlir/Pass/PassBase.td"

def QuantumBufferizationPass : Pass<"quantum-bufferize"> {
    let summary = "Bufferize tensors in quantum operations.";

    let dependentDialects = [
        "bufferization::BufferizationDialect",
        "memref::MemRefDialect"
    ];

    let constructor = "catalyst::createQuantumBufferizationPass()";
}

def QuantumConversionPass : Pass<"convert-quantum-to-llvm"> {
    let summary = "Perform a dialect conversion from Quantum to LLVM (QIR).";

    let dependentDialects = ["LLVM::LLVMDialect"];

    let constructor = "catalyst::createQuantumConversionPass()";
}

def EmitCatalystPyInterfacePass : Pass<"emit-catalyst-py-interface"> {
    let summary = "Emit catalyst python's default interface.";

    let dependentDialects = ["LLVM::LLVMDialect"];

    let constructor = "catalyst::createEmitCatalystPyInterfacePass()";
}

def CopyGlobalMemRefPass : Pass<"cp-global-memref"> {
    let summary = "Copy global memrefs before returning from C interface.";

    let dependentDialects = [
        "memref::MemRefDialect",
        "func::FuncDialect",
        "scf::SCFDialect",
        "LLVM::LLVMDialect"
    ];

    let constructor = "catalyst::createCopyGlobalMemRefPass()";
}

#endif // QUANTUM_PASSES