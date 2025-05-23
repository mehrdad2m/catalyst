// Copyright 2025 Xanadu Quantum Technologies Inc.

// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at

//     http://www.apache.org/licenses/LICENSE-2.0

// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

#include "mlir/IR/Builders.h"
#include "mlir/IR/DialectImplementation.h"
#include "mlir/IR/OpImplementation.h"

#include "QEC/IR/QECDialect.h"
#include "Quantum/IR/QuantumDialect.h"

using namespace mlir;
using namespace catalyst::qec;

//===----------------------------------------------------------------------===//
// QEC dialect definitions.
//===----------------------------------------------------------------------===//

#include "QEC/IR/QECDialectDialect.cpp.inc"

void QECDialect::initialize()
{
    addTypes<
#define GET_TYPEDEF_LIST
#include "QEC/IR/QECDialectTypes.cpp.inc"
        >();

    addOperations<
#define GET_OP_LIST
#include "QEC/IR/QECDialect.cpp.inc"
        >();
}

//===----------------------------------------------------------------------===//
// QEC type definitions.
//===----------------------------------------------------------------------===//

#define GET_TYPEDEF_CLASSES
#include "QEC/IR/QECDialectTypes.cpp.inc"

//===----------------------------------------------------------------------===//
// QEC op definitions.
//===----------------------------------------------------------------------===//

#define GET_OP_CLASSES
#include "QEC/IR/QECDialect.cpp.inc"

//===----------------------------------------------------------------------===//
// QEC op verifiers.
//===----------------------------------------------------------------------===//

LogicalResult PPRotationOp::verify()
{
    if (getInQubits().size() != getPauliProduct().size()) {
        return emitOpError("Number of qubits must match number of pauli operators");
    }
    return mlir::success();
}

LogicalResult PPMeasurementOp::verify()
{
    if (getInQubits().size() != getPauliProduct().size()) {
        return emitOpError("Number of qubits must match number of pauli operators");
    }
    return mlir::success();
}
