# ARMa — 16-bit VHDL Processor

This repository contains the VHDL implementation of a **educational 16-bit processor** (ARMa), built as part of the Computer Architecture course project.  
It includes a modular design with ALU, register file, instruction Memory, data memory, control unit, and testbenches. 

[Download Project Assignment File](https://github.com/AshkanRN/ca-project-gu/releases/download/dl/ProjectCA14032.pdf
) 

---

## Features
- **Registers**: 8 general-purpose registers `R0–R7` (8-bit wide).  
- **Flags**: Carry, Zero, and Sign.  
- **Memory**:  
  - Byte-addressable data memory.  
  - Instruction memory (16-bit word wide).  
- **Supported instructions**:  
  `ADD`, `SUB`, `ADDI`, `MOV`, `CMP`, `XOR`, `AND`, `SHL`, `SHR`, `COM`, `INC`, `LD`, `ST`, `BR`, `BZ`, `BNZ`.  
- Modular components: `ALU`, `Register_Files`, `Program_Counter`, `Instruction_Memory`, `Data_Memory`, `Control_Unit`.

---

## Instruction Formats

### R-type
| Field   | Bits   | Description            |
|---------|--------|------------------------|
| opCode  | 15–12  | Operation code         |
| Rd      | 11–9   | Destination register   |
| Rn      | 8–6    | First source register  |
| Rm      | 5–3    | Second source register |
| Unused  | 2–0    | -                      |

---

### D-type
| Field   | Bits   | Description                        |
|---------|--------|------------------------------------|
| opCode  | 15–12  | Operation code                     |
| Rt      | 11–9   | Source/Destination register        |
| Rn      | 8–6    | Base register                      |
| Address | 7–0    | Memory address (immediate offset)  |

---

### I-type
| Field      | Bits   | Description             |
|------------|--------|-------------------------|
| opCode     | 15–12  | Operation code          |
| Rd         | 11–9   | Destination register    |
| Rn         | 8–6    | Source register         |
| Immediate  | 7–0    | Immediate value         |

---

### B-type (BR)
| Field     | Bits   | Description            |
|-----------|--------|------------------------|
| opCode    | 15–12  | Operation code         |
| Unused    | 11–8   | -                      |
| Immediate | 7–0    | Branch target offset   |

---

### CB-type (BZ, BNZ)
| Field     | Bits   | Description            |
|-----------|--------|------------------------|
| opCode    | 15–12  | Operation code         |
| Rt        | 11–9   | Source register        |
| Immediate | 7–0    | Branch target offset   |



## Instruction Set (Opcode Map)

| Opcode | Mnemonic | Description                  |
|--------|----------|------------------------------|
| 0000   | ADD      | Add two registers            |
| 0001   | SUB      | Subtract two registers       |
| 0010   | ADDI     | Add immediate                |
| 0011   | MOV      | Move register/immediate      |
| 0100   | CMP      | Compare registers (set flags)|
| 0101   | XOR      | Bitwise XOR                  |
| 0110   | AND      | Bitwise AND                  |
| 0111   | SHL      | Shift left by 1 bit          |
| 1000   | SHR      | Shift right by 1 bit         |
| 1001   | COM      | Complement (NOT)             |
| 1010   | INC      | Increment register by 1      |
| 1011   | LD       | Load from memory             |
| 1100   | ST       | Store to memory              |
| 1101   | BR       | Unconditional branch         |
| 1110   | BZ       | Branch if zero               |
| 1111   | BNZ      | Branch if not zero           |
