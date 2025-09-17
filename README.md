# ARMa — 16-bit VHDL Processor

VHDL implementation of an **educational processor** — instructions are 16 bits wide, while the datapath and registers are 8 bits (all arithmetic and logic operations are performed on 8-bit values).
 

[Project Assignment File](https://github.com/AshkanRN/ca-project-gu/releases/download/dl/ProjectCA14032.pdf) 

---

## Features
- **Registers**: 8 general-purpose registers `R0–R7` (8-bit wide).  
- **Flags**: Carry, Zero, and Sign.  
- **Memory**:  
  - Byte-addressable data memory.  
  - Instruction memory (16-bit wide).  
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

| Opcode | Example            | Description                                |
|--------|--------------------|--------------------------------------------|
| 0000   | ADD R0, R1, R2     | Add two registers (R0 = R1 + R2)           |
| 0001   | SUB R0, R1, R2     | Subtract two registers (R0 = R1 - R2)      |
| 0010   | ADDI R0, R1, #5    | Add immediate (R0 = R1 + 5)                |
| 0011   | MOV R0, R1         | Move register (R0 = R1)                    |
| 0100   | CMP R1, R2         | Compare registers (set flags based on R1-R2) |
| 0101   | XOR R0, R1, R2     | Bitwise XOR (R0 = R1 XOR R2)                 |
| 0110   | AND R0, R1, R2     | Bitwise AND (R0 = R1 & R2)                 |
| 0111   | SHL R0, R1         | Shift left by 1 bit (R0 = R1 << 1)         |
| 1000   | SHR R0, R1         | Shift right by 1 bit (R0 = R1 >> 1)        |
| 1001   | COM R0, R1         | Complement (R0 = NOT R1)                   |
| 1010   | INC R0, R1         | Increment register by 1 (R0 = R1 + 1)      |
| 1011   | LD R0, [R1+4]      | Load from memory (R0 = MEM[R1+4])          |
| 1100   | ST R0, [R1+4]      | Store to memory (MEM[R1+4] = R0)           |
| 1101   | BR #20             | Unconditional branch to address 20         |
| 1110   | BZ R1, #20         | Branch to address 20 if R1 == 0            |
| 1111   | BNZ R1, #20        | Branch to address 20 if R1 != 0            |

