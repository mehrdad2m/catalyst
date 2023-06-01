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

#ifndef QUANTUM_INTERFACES
#define QUANTUM_INTERFACES

include "mlir/IR/OpBase.td"

def QuantumGate : OpInterface<"QuantumGate"> {
    let description = [{
        This interface provides a generic way to interact with instructions that are
        considered quantum logic gates. These are characterized operating on at least
        one qubit value, and returning the same amount of qubit values.
    }];

    let cppNamespace = "::catalyst::quantum";

    let methods = [
        InterfaceMethod<
            "Return all operands which are considered input qubit values.",
            "mlir::ValueRange", "getQubitOperands"
        >,
        InterfaceMethod<
            "Return all results which are considered output qubit values.",
            "mlir::ValueRange", "getQubitResults"
        >,
    ];

    let verify = [{
        auto gate = mlir::cast<ConcreteOp>($_op);

        if (gate.getQubitOperands().size() < 1)
            return $_op->emitOpError("must have at least 1 qubit");

        if (gate.getQubitOperands().size() != gate.getQubitResults().size())
            return $_op->emitOpError("number of qubits in input and output must be the same");

        return mlir::success();
    }];
}

// TODO: Make this interface inherit from QuantumGate (available since llvm/llvm-project@83a635c).
def DifferentiableGate : OpInterface<"DifferentiableGate"> {
    let description = [{
        This interface provides a generic way to interact with differentiable
        quantum instructions. These are quantum operations with differentiable
        gate parameters.
    }];

    let cppNamespace = "::catalyst::quantum";

    let methods = [
        InterfaceMethod<
            "Return all operands which are considered differentiable gate parameters.",
            "mlir::ValueRange", "getDiffParams"
        >,
        InterfaceMethod<
            "Return the starting index at which to find differentiable operands in the Operation*."
            "Differentiable gate parameter operands do not need to be stored in a single ODS "
            "argument or be located in a particular position, but are assumed to be contiguous.",
            "size_t", "getDiffOperandIdx"
        >,
    ];
}

def MeasurementProcess : OpInterface<"MeasurementProcess"> {
    let description = [{
        This interface provides a generic way to interact with quantum measurement processes.
        These are instructions that represent some information extraction procedure on the
        underlying statevector. On simulators, they may be implemented by direct manipulation
        of the statevector, but on hardware they typically turn into procedures over the quantum
        program as a whole, usually requiring many executions of the same circuit.
    }];

    let cppNamespace = "::catalyst::quantum";
}

#endif // QUANTUM_INTERFACES